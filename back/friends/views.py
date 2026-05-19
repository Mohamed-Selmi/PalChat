from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework.exceptions import ValidationError
from rest_framework.authentication import SessionAuthentication
from .models import FriendList,FriendRequest
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.contrib.auth import get_user_model
from .serializers import ShowFriendRequestSerializer,FriendSerializer
from django.shortcuts import render
User = get_user_model()

class SendFriendRequestView(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        sending_user = request.user
        receiving_user_id = request.data.get('receiving_user')

        friend_list, created = FriendList.objects.get_or_create(user=sending_user)

        if sending_user.user_id == receiving_user_id:
            return Response({'status': False, 'message': 'Cannot send friend request to yourself.'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            receiver = User.objects.get(user_id=receiving_user_id)
        except User.DoesNotExist:
            return Response({'status': False, 'message': 'Receiver user not found.'}, status=status.HTTP_404_NOT_FOUND)

        existing_request = FriendRequest.objects.filter(sender=sending_user, receiver=receiver)
        if existing_request.exists():
            return Response({'status': False, 'message': 'Friend request already sent.'}, status=status.HTTP_400_BAD_REQUEST)

        if friend_list.is_friend(receiver):
            return Response({'status': False, 'message': 'You are already friends with this user.'}, status=status.HTTP_400_BAD_REQUEST)

        friend_request = FriendRequest.objects.create(sender=sending_user, receiver=receiver, active_status=True)
        content = {
            'sender': sending_user.username,
            'receiver': receiver.username,
            'friend_request': friend_request.active_status
        }
        return Response({'status': True, 'message': 'Friend request sent successfully.', 'data': content}, status=status.HTTP_201_CREATED)


    

class ShowFriendRequestsView(APIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = ShowFriendRequestSerializer

    def get(self,request):
        user=request.user
        requests=FriendRequest.objects.filter(receiver=user,active_status=True)
        serializer = self.serializer_class(requests, many=True)
        response_data={
            'status': True,
            'message': 'User Friend requests',
            'content': serializer.data,
        }
        return Response(response_data,status=status.HTTP_200_OK)
    

class ShowSentFriendRequestsView(APIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = ShowFriendRequestSerializer

    def get(self,request):
        user=request.user
        requests=FriendRequest.objects.filter(sender=user,active_status=True)
        serializer = self.serializer_class(requests, many=True)
        response_data={
            'status': True,
            'message': 'User Friend requests',
            'content': serializer.data,
        }
        return Response(response_data,status=status.HTTP_200_OK)
    


class AcceptFriendRequestView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, friend_request_id):
        try:
            friend_request = FriendRequest.objects.get(id=friend_request_id)
            friend_request.AcceptFriendRequest()
            return Response("Friend request accepted successfully", status=status.HTTP_200_OK)
        except FriendRequest.DoesNotExist:
            return Response("Friend request does not exist", status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response(str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class DeclineFriendRequestView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, friend_request_id):
        try:
            friend_request = FriendRequest.objects.get(id=friend_request_id)
            friend_request.DeclineFriendRequest()
            return Response("Friend request declined successfully", status=status.HTTP_200_OK)
        except FriendRequest.DoesNotExist:
            return Response("Friend request does not exist", status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response(str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class CancelFriendRequestView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request, friend_request_id):
        try:
            friend_request = FriendRequest.objects.get(id=friend_request_id)
            friend_request.CancelFriendRequest()
            return Response("Friend request canceled successfully", status=status.HTTP_200_OK)
        except FriendRequest.DoesNotExist:
            return Response("Friend request does not exist", status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response(str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class ShowFriendsView(APIView):
    authentication_classes = [JWTAuthentication, SessionAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            user = request.user
            friend_list = FriendList.objects.get(user=user)
            friends = friend_list.get_friends()
            serializer = FriendSerializer(friends, many=True)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except FriendList.DoesNotExist:
            return Response("Friend list does not exist for this user", status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response(str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class RemoveFriendView(APIView):
    authentication_classes = [JWTAuthentication, SessionAuthentication]
    permission_classes = [IsAuthenticated]
    def post(self,request):
            friend_id=request.data.get('friend_id')
            user=request.user
            friend = User.objects.get(user_id=friend_id)
            user_friend_list = FriendList.objects.get(user=user)
            user_friend_list.unfriend(friend)
            return Response({'message': 'Friend removed successfully'}, status=status.HTTP_200_OK)






class VisitUserProfile(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self, request, user_id):
        try:


            profile_user = User.objects.get(user_id=user_id)

            content = {
                'user_id': profile_user.user_id,
                'username': profile_user.username,
                'email': profile_user.email,
                'picture_url': profile_user.get_picture_url(),
                'are_friends': False,
                'sender': False,
                'receiver': False
            }

            response_content = {
                'status': True,
                'message': 'User Profile Data',
                'data': content
            }

            return Response(response_content, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(str(e), status=status.HTTP_400_BAD_REQUEST)

