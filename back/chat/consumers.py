import json
from channels.db import database_sync_to_async
from channels.layers import get_channel_layer
from channels.generic.websocket import AsyncWebsocketConsumer,WebsocketConsumer,AsyncJsonWebsocketConsumer
from .middleware import JWTAuthMiddleware
from asgiref.sync import async_to_sync
from django.contrib.auth import get_user_model
from django.db.models import Q
from django.core.files.uploadedfile import InMemoryUploadedFile
import base64
from django.core.files.base import ContentFile
from .models import Conversation, GroupMembers, Message, UserInbox
import io
User = get_user_model()
class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        self.group_id = self.scope['url_route']['kwargs']['group_id']
        self.user = self.scope.get('user')
        if self.user is None:
            await self.close()
            return

        await self.save_user_channel()
        await self.channel_layer.group_add(
            self.group_id,
            self.channel_name
        )
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(
            self.group_id,
            self.channel_name
        )
        await self.delete_user_channel()
        await super().disconnect(close_code)

    async def receive(self, text_data=None, bytes_data=None):
        if text_data:
            await self.receive_text(text_data)
        elif bytes_data:
            await self.receive_image(bytes_data)

    async def receive_text(self, text_data):
        try:
            message = text_data
        except KeyError:
            return
        message_response = await self.save_message(self.group_id, self.user, message)
        await self.channel_layer.group_send(
            self.group_id,
            {
                'type': 'chat.message',
                'message': message_response
            }
        )

    async def receive_image(self, bytes_data):
        try:
            format, imgstr = bytes_data.split(';base64,')
            ext = format.split('/')[-1]
            image_data = base64.b64decode(imgstr)
            message_response = await self.save_message(self.group_id, self.user, image_data, is_image=True)
            await self.channel_layer.group_send(
                self.group_id,
                {
                    'type': 'chat.message',
                    'message': message_response
                }
            )
        except Exception as e:
            print(f"Error handling image: {e}")

    async def chat_message(self, event):
        await self.send(text_data=json.dumps(event['message']))

    @database_sync_to_async
    def save_user_channel(self):
        try:
            self.user = self.scope['user']
        except KeyError:
            pass
        else:
            UserInbox.objects.create(
                user=self.user,
                channel=self.channel_name
            )

    @database_sync_to_async
    def delete_user_channel(self):
        if self.user is not None:
            UserInbox.objects.filter(user_id=self.user.user_id).delete()

    @database_sync_to_async
    def save_message(self, group_id, user, content):
        conversation = Conversation.objects.get(id=group_id)
        conversation.last_message = content
        conversation.last_sent_user = user
        conversation.save()
        message = Message.objects.create(
            conversation=conversation,
            sender=user,
            content=content
        )
        message_response = {
            'message_id': message.id,
            'message_conversation': conversation.id,
            'message_content': message.content,
            'message_sender': message.sender.username,
            'message_timestamp': str(message.timestamp),
            'message_image_url': message.get_picture_url(), 
            
        }
        return message_response