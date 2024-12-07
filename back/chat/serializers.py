
from rest_framework import serializers
from .models import Conversation, Message
from accounts.serializers import UserSerializer
class ConversationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Conversation
        fields = '__all__'
class MessageSerializer(serializers.ModelSerializer):
    picture_url = serializers.SerializerMethodField()
    sender = UserSerializer(read_only=True)

    class Meta:
        model = Message
        fields = ['sender', 'conversation_id', 'timestamp', 'content', 'picture_url']
    def get_picture_url(self, obj):
        return obj.get_picture_url()
    
class CreateMessageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Message
        fields = ['conversation', 'content', 'image']

    def create(self, validated_data):
        validated_data['sender'] = self.context['request'].user
        return super().create(validated_data)