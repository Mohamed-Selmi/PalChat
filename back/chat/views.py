from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from rest_framework.authentication import SessionAuthentication
from channels.layers import get_channel_layer
from asgiref.sync import async_to_sync
from .models import Message,Conversation,GroupMembers
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.contrib.auth import get_user_model
from django.shortcuts import render
from .serializers import MessageSerializer,CreateMessageSerializer
import random
User = get_user_model()

class Conversationsview(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self, request):
        user = request.user
        conversation_ids = GroupMembers.objects.filter(user=user).values_list('conversation_id', flat=True).distinct()
        conversations = Conversation.objects.filter(id__in=conversation_ids).values(
            'id', 'name', 'last_message', 'last_sent_user__username'
        )
        response = {
            'status': True,
            'message': 'Conversation list',
            'content': list(conversations)
        }
        return Response(response, status=status.HTTP_200_OK)



class RoomMessagesView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, conversation_id):
        messages = Message.objects.filter(conversation_id=conversation_id)
        serializer = MessageSerializer(messages, many=True)
        response = {
            'status': True,
            'message': 'ConversationMessages',
            'content': serializer.data
        }
        return Response(response, status=status.HTTP_200_OK)
    

class CreateGroup(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        user = request.user
        name = request.data.get('name')
        conversation = Conversation.objects.create(name=name,creator=user)
        GroupMembers.objects.create(user=user, conversation=conversation)
        response = {
            'status': True,
            'message': 'Group Created',
            'group_id': conversation.id
        }
        return Response(response, status=status.HTTP_201_CREATED)
    
    
class AddGroupMembers(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, group_id):
        try:
            new_user_email = request.data.get('email')
            new_user = User.objects.get(email=new_user_email)
            conversation = Conversation.objects.get(id=group_id)
            
            if GroupMembers.objects.filter(user=new_user, conversation=conversation).exists():
                raise ValidationError('User is already a member of the group')

            GroupMembers.objects.create(user=new_user, conversation=conversation)
            response = {
                'status': True,
                'message': 'User added to the group',
            }
            return Response(response, status=status.HTTP_200_OK)
        except User.DoesNotExist:
            return Response({'status': False, 'message': 'User does not exist'}, status=status.HTTP_400_BAD_REQUEST)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Conversation does not exist'}, status=status.HTTP_400_BAD_REQUEST)
class RemoveGroupMembers(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, group_id):
        try:
            removed_user_id = request.data.get("member_id")
            conversation_id = group_id
            member = GroupMembers.objects.get(user_id=removed_user_id, conversation_id=conversation_id)
            conversation = Conversation.objects.get(id=conversation_id)
            
            if request.user == member.user:
                return Response({'status': False, 'message': 'You cannot remove yourself from the group'}, status=status.HTTP_403_FORBIDDEN)
            
            if request.user == conversation.creator:
                member.delete()
                return Response({'status': True, 'message': 'Member removed successfully'}, status=status.HTTP_200_OK)
            else:
                return Response({'status': False, 'message': 'You are not the creator of this group'}, status=status.HTTP_403_FORBIDDEN)
        except GroupMembers.DoesNotExist:
            return Response({'status': False, 'message': 'Member not found'}, status=status.HTTP_404_NOT_FOUND)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Conversation not found'}, status=status.HTTP_404_NOT_FOUND)


class GroupDetail(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self, request, group_id):
        try:
            conversation = Conversation.objects.get(id=group_id)
            group_members = GroupMembers.objects.filter(conversation=conversation)
            
            response_data = {
                'conversation': conversation.id,
                'name': conversation.name,
                'members': [{'user_id': member.user.user_id,'email': member.user.email, 'username': member.user.username,'picture_url': member.user.get_picture_url()} for member in group_members]
            }
            return Response(response_data, status=status.HTTP_200_OK)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Conversation does not exist'}, status=status.HTTP_404_NOT_FOUND)


class DeleteGroup(APIView):
    permission_classes = (IsAuthenticated,)

    def delete(self, request, group_id):
        try:
            conversation = Conversation.objects.get(id=group_id)
            if request.user == conversation.creator:
                conversation.delete()
                return Response({'status': True, 'message': 'Group deleted successfully'}, status=status.HTTP_204_NO_CONTENT)
            else:
                return Response({'status': False, 'message': 'You are not the creator of this group'}, status=status.HTTP_403_FORBIDDEN)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Group not found'}, status=status.HTTP_404_NOT_FOUND)


class CreateMessageView(APIView):
    permission_classes = [IsAuthenticated]
    authentication_classes = (JWTAuthentication, SessionAuthentication)

    def post(self, request, *args, **kwargs):
        serializer = CreateMessageSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            message = serializer.save()
            channel_layer = get_channel_layer()
            group_id = str(message.conversation.id) 
            message_response = MessageSerializer(message).data 
            async_to_sync(channel_layer.group_send)(
                group_id,
                {
                    'type': 'chat.message',
                    'message': message_response
                }
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    
class LeaveGroup(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request, group_id):
        user = request.user
        try:
            conversation = Conversation.objects.get(id=group_id)
            member = GroupMembers.objects.get(user=user, conversation=conversation)

            if user == conversation.creator:
                other_members = GroupMembers.objects.filter(conversation=conversation).exclude(user=user)
                if not other_members.exists():
                    conversation.delete()
                    return Response({'status': True, 'message': 'Group deleted as there are no more members'}, status=status.HTTP_204_NO_CONTENT)
                new_creator = random.choice(other_members)
                conversation.creator = new_creator.user
                conversation.save()
            
            member.delete()
            return Response({'status': True, 'message': 'You have left the group successfully'}, status=status.HTTP_200_OK)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Conversation does not exist'}, status=status.HTTP_404_NOT_FOUND)
        except GroupMembers.DoesNotExist:
            return Response({'status': False, 'message': 'You are not a member of this group'}, status=status.HTTP_400_BAD_REQUEST)




