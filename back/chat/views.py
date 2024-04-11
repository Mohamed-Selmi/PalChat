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
        conversation = Conversation.objects.create(name=name)
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


class GroupDetail(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self, request, group_id):
        try:
            conversation = Conversation.objects.get(id=group_id)
            group_members = GroupMembers.objects.filter(conversation=conversation)
            
            response_data = {
                'conversation': conversation.id,
                'name': conversation.name,
                'members': [{'email': member.user.email, 'username': member.user.username,'picture_url': member.user.get_picture_url()} for member in group_members]
            }
            return Response(response_data, status=status.HTTP_200_OK)
        except Conversation.DoesNotExist:
            return Response({'status': False, 'message': 'Conversation does not exist'}, status=status.HTTP_404_NOT_FOUND)


def index(request):
    return render(request, "chat/index.html")


def room(request, room_name):
    return render(request, "chat/room.html", {"room_name": room_name})



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

    






class UploadImage(APIView):
    permission_classes = (IsAuthenticated,)
    authentication_classes = (JWTAuthentication, SessionAuthentication)

    def post(self, request, format=None):
        group_id = request.data.get('group_id')
        user = request.user  
        serializer = MessageSerializer(data=request.data, partial=True)
        if serializer.is_valid():
            message = serializer.save(sender=user, conversation_id=group_id)
            image_url = message.get_picture_url()
            channel_layer = get_channel_layer()
            async_to_sync(channel_layer.group_send)(
                group_id,
                {
                    'type': 'chat.message',
                    'message': {
                        'message_id': message.id,
                        'message_conversation': group_id,
                        'message_content': message.content,
                        'message_sender': message.sender.username,
                        'message_timestamp': str(message.timestamp),
                        'message_image': image_url 
                    }
                }
            )

            return Response({'image_url': image_url, 'message': 'Image uploaded and message created successfully'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)