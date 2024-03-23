import json
from channels.db import database_sync_to_async
from channels.layers import get_channel_layer
from channels.generic.websocket import AsyncWebsocketConsumer,WebsocketConsumer,AsyncJsonWebsocketConsumer

from asgiref.sync import async_to_sync
from django.contrib.auth import get_user_model
from django.db.models import Q
from django.core.files.uploadedfile import InMemoryUploadedFile
import base64
from .models import Conversation, GroupMembers, Message, UserInbox
import io
User = get_user_model()
class ChatConsumer(AsyncJsonWebsocketConsumer):

    async def connect(self):
        self.user_id = self.scope['url_route']['kwargs']['user_id']
        await self.save_user_channel()
        await self.accept()
    async def disconnect(self, close_code):
        await self.delete_user_channel()
        await self.disconnect(close_code)

    async def receive_json(self, text_data=None, byte_data=None):
        message = text_data['message']
        self.to_user = text_data['to_user']
        to_user_channel, to_user_id = await self.get_user_channel(self.to_user)
        self.group_name = f'{self.user_id}-{self.to_user}'
        message_response = await self.save_message(self.group_name, self.user, message)
        message_response['type'] = 'send.message'

        channel_layer = get_channel_layer()

        await self.channel_layer.group_add(
            self.group_name,
            str(self.channel_name)
        )
        if to_user_channel != None and to_user_id != None:
            await self.channel_layer.group_add(
                self.group_name,
                str(to_user_channel)
            )

        await channel_layer.group_send(
            self.group_name, message_response
        )
    async def send_message(self, event):
        print(event)
        await self.send(text_data=json.dumps(event))
    @database_sync_to_async
    def get_user_channel(self, to_user):
        try:
            send_user_channel = UserInbox.objects.filter(
                user=to_user).latest('id')
            channel_name = send_user_channel
            user_id = send_user_channel.user.user_id
        except Exception as e:
            channel_name = None
            user_id = None

        return channel_name, user_id

    @database_sync_to_async
    def save_user_channel(self):
        self.user = User.objects.get(user_id=self.user_id)

        UserInbox.objects.create(
            user=self.user,
            channel=self.channel_name
        )

    @database_sync_to_async
    def delete_user_channel(self):
        UserInbox.objects.filter(user=self.user).delete()

    @database_sync_to_async
    def save_message(self, room, user, content):
        try:
            GroupMembers.objects.get_or_create(
                Q(conversation__name=f'{self.user.user_id}-{self.to_user}') |
                Q(conversation__name=f'{self.to_user}-{self.user.user_id}'), user=self.user)
            GroupMembers.objects.get_or_create(
                Q(conversation__name=f'{self.user.user_id}-{self.to_user}') |
                Q(conversation__name=f'{self.to_user}-{self.user.user_id}'), user=self.to_user)
        except Exception as e:
            print(e)

        try:
            Conversation = Conversation.objects.get(Q(name=f'{self.user.user_id}-{self.to_user}') |
                                            Q(name=f'{self.to_user}-{self.user.user_id}'))
            Conversation.last_message = content 
            Conversation.last_sent_user = self.user
        except Exception as e:
            Conversation = Conversation.objects.create(
                name=str(room),
                last_message=content,
                last_sent_user=self.user
            )

        message = Message.objects.create(
            room=Conversation, user=self.user, content=content
        )

        message_response = {
            'message_id': message.id,
            'message_conversation': Conversation.id,
            'message_content': message.content,
            'message_sender': str(message.sender.user_id),
            'message_timestamp': str(message.timestamp),
        }

        return message_response