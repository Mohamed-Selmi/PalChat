from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Message,Conversation,GroupMembers,UserInbox
from django.contrib.auth import get_user_model
from django.shortcuts import render
User = get_user_model()
#show all the rooms the user is in
class Conversationsview(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self,request,user_id):
        user=request.user
        groupmembers=GroupMembers
        Conversation_ids = list(GroupMembers.objects.filter(user=user).values_list('conversation_id',flat=True))
        Conversations= list(GroupMembers.objects.exclude(user_id=user_id).filter(
        conversation__id__in=Conversation_ids).values('user__username', 'user__user_id', 'conversation__id', 'conversation__name', 'conversation__last_message', 'conversation__last_sent_user'))
        response={
            'status':True,
            'message':'Conversationlist',
            'content':Conversations
        }
        return Response(response, status=status.HTTP_200_OK)


#shows all the messages in a room
class RoomMessagesView(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self,request,user_id,conversation_id=None):
        user=request.user
        if conversation_id:
            Messages=list(Message.objects.filter(conversation_id=conversation_id).values())
        else:
             Messages = list(Message.objects.filter(sender=user_id).values())
        response={
            'status':True,
            'message':'ConversationMessages',
            'content':Messages
        }
        return Response(response, status=status.HTTP_200_OK)

def index(request):
    return render(request, "chat/index.html")


def room(request, room_name):
    return render(request, "chat/room.html", {"room_name": room_name})