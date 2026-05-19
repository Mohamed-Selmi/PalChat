from django.urls import path
from .views import RoomMessagesView,Conversationsview,CreateGroup,AddGroupMembers,GroupDetail,CreateMessageView,DeleteGroup,RemoveGroupMembers,LeaveGroup
from . import views
urlpatterns = [
    path('room-messages/<int:conversation_id>/', RoomMessagesView.as_view(), name='room_messages'),
    path('user-chatrooms/', Conversationsview.as_view(), name='user_chatrooms'),
    path('create-group/', CreateGroup.as_view(), name='create_group'),
    path('delete-group/<int:group_id>/', DeleteGroup.as_view(), name='delete_group'),
    path('group-detail/<int:group_id>/add-members/', AddGroupMembers.as_view(), name='add_members'),
    path('group-detail/<int:group_id>/', GroupDetail.as_view(), name='group_detail'),
    path('create-message',CreateMessageView.as_view(),name='create_message'),
    path('group-detail/<int:group_id>/remove-members/', RemoveGroupMembers.as_view(), name='remove_members'),
    path('leave-group/<int:group_id>/', LeaveGroup.as_view(), name='leave_group'),

]