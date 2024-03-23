from django.contrib import admin

from .models import GroupMembers, Message, Conversation, UserInbox

# Register your models here.
admin.site.register(GroupMembers)
admin.site.register(Message)
admin.site.register(UserInbox)
admin.site.register(Conversation)