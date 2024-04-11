from django.urls import re_path,path
from . import consumers
from .consumers import ChatConsumer
websocket_urlpatterns = [
    re_path(r'ws/chat/(?P<group_id>\w+)/$', consumers.ChatConsumer.as_asgi()),
]
