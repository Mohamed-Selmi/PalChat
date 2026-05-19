from rest_framework import serializers
from .models import FriendRequest, FriendList
from django.contrib.auth import get_user_model
User = get_user_model()
class ShowFriendRequestSerializer(serializers.ModelSerializer):
    sender_picture_url = serializers.SerializerMethodField()
    receiver_picture_url = serializers.SerializerMethodField()
    sender_username = serializers.SerializerMethodField()
    receiver_username = serializers.SerializerMethodField()
    sender_email= serializers.SerializerMethodField()
    receiver_email= serializers.SerializerMethodField()
    class Meta:
        model = FriendRequest
        fields = ('id', 'sender', 'sender_username','sender_email', 'receiver', 'receiver_username','receiver_email', 'active_status', 'created_at', 'sender_picture_url', 'receiver_picture_url')

    def get_sender_username(self, obj):
        return obj.sender.username
    

    def get_receiver_username(self, obj):
        return obj.receiver.username

    def get_sender_picture_url(self, obj):
        return obj.sender.get_picture_url()

    def get_receiver_picture_url(self, obj):
        return obj.receiver.get_picture_url()
    def get_receiver_email(self, obj):
        return obj.receiver.email
    def get_sender_email(self, obj):
        return obj.sender.email
    

  



class FriendSerializer(serializers.ModelSerializer):
    picture_url = serializers.SerializerMethodField()

    def get_picture_url(self, user):
        return user.get_picture_url()

    class Meta:
        model = User
        fields = ('user_id', 'email', 'username', 'picture_url')
