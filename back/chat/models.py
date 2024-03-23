from django.db import models
from django.conf import settings
from django.utils import timezone
from django.contrib.auth import get_user_model
User = get_user_model()
class Conversation(models.Model):
    name = models.CharField(max_length=256)
    last_message = models.CharField(max_length=1024, null=True)
    last_sent_user = models.ForeignKey(User, on_delete=models.PROTECT, null=True)
    def __str__(self):
        return self.name

  
class Message(models.Model):
    sender = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='sent_messages')
    conversation = models.ForeignKey(Conversation, on_delete=models.CASCADE, related_name='messages')
    timestamp = models.DateTimeField(default=timezone.now)
    content = models.TextField(blank=True)
    image = models.ImageField(upload_to='message_images/', blank=True, null=True)
    def displaymessage(self):
        if self.image:
            return (self.image.url)
        else:
            return self.content
    def last_10_messages(self):
        return Message.objects.order_by('-timestamp').all()[:10]
        
class UserInbox(models.Model):
    channel = models.CharField(max_length=256)
    user = models.ForeignKey(User, on_delete=models.PROTECT)
    def __str__(self):
        return str(self.channel)



class GroupMembers(models.Model):
    user = models.ForeignKey(User, on_delete=models.PROTECT)
    conversation = models.ForeignKey(Conversation, on_delete=models.PROTECT)
    joined_at = models.DateTimeField(auto_now_add=True)
    left_at = models.DateTimeField(blank=True, null=True)