from django.urls import path
from .views import *

urlpatterns = [
    path('send-friend-request/', SendFriendRequestView.as_view(), name='send_friend_request'),
    path('send-friend-request/<int:receiving_user>/', SendFriendRequestView.as_view(), name='send_friend_request'),
    path('show-friend-requests/', ShowFriendRequestsView.as_view(), name='show_friend_requests'),
    path('accept-friend-request/<int:friend_request_id>/', AcceptFriendRequestView.as_view(), name='accept_friend_request'),
    path('decline-friend-request/<int:friend_request_id>/', DeclineFriendRequestView.as_view(), name='decline_friend_request'),
    path('cancel-friend-request/<int:friend_request_id>/', CancelFriendRequestView.as_view(), name='cancel_friend_request'),
    path('show-friends/', ShowFriendsView.as_view(), name='show_friends'),
    path('cancel-friend-request/', CancelFriendRequestView.as_view(), name='cancel_friend_request'),
    path('visit-user-profile/<int:user_id>/', VisitUserProfile.as_view(), name='visit_user_profile'),
    path('remove-friend/', RemoveFriendView.as_view(), name='remove_friend'),
    path('sent-friend-requests/', ShowSentFriendRequestsView.as_view(), name='sent_friend_requests'),
]
