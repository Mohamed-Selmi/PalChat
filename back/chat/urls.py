from django.urls import path
from .views import RoomMessagesView,Conversationsview,index,room,CreateGroup,AddGroupMembers,GroupDetail,UploadImage,CreateMessageView
from . import views
urlpatterns = [
    
    path('room-messages/<int:conversation_id>/', RoomMessagesView.as_view(), name='room_messages'),
    path('user-chatrooms/', Conversationsview.as_view(), name='user_chatrooms'),
    path('create-group/', CreateGroup.as_view(), name='create_group'),
    path('group-detail/<int:group_id>/add-members/', AddGroupMembers.as_view(), name='add_members'),
    path('group-detail/<int:group_id>/', GroupDetail.as_view(), name='group_detail'),
    path('upload-image',UploadImage.as_view(),name='upload_image'),
    path('create-message',CreateMessageView.as_view(),name='create_message'),

]