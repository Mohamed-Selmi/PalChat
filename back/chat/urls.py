from django.urls import path
from .views import RoomMessagesView,Conversationsview,index,room
from . import views
urlpatterns = [
    path('room-messages/<str:user_id>/', RoomMessagesView.as_view(), name='room_messages'),
    path('room-messages/<str:user_id>/<int:conversation_id>/', RoomMessagesView.as_view(), name='room_messages'),
    path('user-chatrooms/<str:user_id>/', Conversationsview.as_view(), name='user_chatrooms'),
    path("", views.index, name="index"),
    path("<str:room_name>/", views.room, name="room"),
]