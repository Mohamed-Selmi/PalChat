from rest_framework import serializers
from .models import FriendRequest, FriendList
from django.contrib.auth import get_user_model
User = get_user_model()
class ShowFriendRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = FriendRequest
        fields = '__all__'
class FriendSerializer(serializers.ModelSerializer):
    picture_url = serializers.SerializerMethodField()

    def get_picture_url(self, user):
        return user.picture_url

    class Meta:
        model = User
        fields = ('user_id', 'email', 'username', 'picture_url')