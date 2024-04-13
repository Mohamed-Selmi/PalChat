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
    def post(self,request):
        sending_user=request.user
        receiving_user=request.data.get('receiving_user')
        try:
            receiver = User.objects.get(user_id=receiving_user)
        except User.DoesNotExist:
            return Response({'status': False, 'message': 'Receiver user not found.'}, status=status.HTTP_404_NOT_FOUND)     
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
        friendrequests=list(requests.values('id', 'sender__user_id', 'sender__username', 'sender__picture'))
        response_data={
            'status': True,
            'message': 'User Friend requests',
            'content':friendrequests,
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


class CancelFriendRequestView(APIView):
    pass 


class VisitUserProfile(APIView):
    permission_classes = (IsAuthenticated,)
    def get(self, request, email):
        try:
            authenticated_user = request.user

            profile_user = User.objects.get(email=email)

            try:
                friend_list_user = FriendList.objects.get(
                    user=authenticated_user)
            except:
                friend_list_user = None

            user_friend = False

            content = {
                'user_id': profile_user.user_id,
                'username': profile_user.username,
                'email': profile_user.email,
                'picture_url': profile_user.get_picture_url(),
                'are_friends': False,
                'sender': False,
                'receiver': False
            }

            if friend_list_user:
                if friend_list_user.is_friend(profile_user):
                    user_friend = True

                    content['are_friends'] = True

                    response_content = {
                        'status': True,
                        'message': 'User Profile Data',
                        'data': content
                    }
                    return Response(response_content, status=status.HTTP_200_OK)

            if not user_friend:
                try:
                    friend_request_sender = FriendRequest.objects.filter(
                        sender=authenticated_user, receiver=profile_user)
                except:
                    friend_request_sender = None

                if friend_request_sender:
                    content['sender'] = True

                    response_content = {
                        'status': True,
                        'message': 'User Profile Data',
                        'data': content
                    }

                    return Response(response_content, status=status.HTTP_200_OK)

            if not friend_request_sender:
                try:
                    friend_request_receiver = FriendRequest.objects.filter(
                        sender=profile_user, receiver=authenticated_user)
                except:
                    friend_request_receiver = None

                if friend_request_receiver:
                    content['receiver'] = True

                    response_content = {
                        'status': True,
                        'message': 'User Profile Data',
                        'data': content
                    }

                    return Response(response_content, status=status.HTTP_200_OK)

            response_content = {
                'status': True,
                'message': 'User Profile Data',
                'data': content
            }

            return Response(response_content, status=status.HTTP_200_OK)
        except Exception as e:
            return Response(str(e), status=status.HTTP_400_BAD_REQUEST)

