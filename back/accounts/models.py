from django.db import models
import urllib.parse
from django.contrib.auth.base_user import BaseUserManager
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.conf import settings
class AppUserManager(BaseUserManager):
	def create_user(self, username,email, password=None):
		if not email:
			raise ValueError('An email is required.')
		if not password:
			raise ValueError('A password is required.')
		email = self.normalize_email(email)
		user = self.model(email=email,username=username
					)
		user.set_password(password)
		user.save()
		return user
	def create_superuser(self, email, username, password):
		user = self.create_user(
        username,
		email,
        password=password
    	)
		user.is_active=True
		user.is_superuser = True
		user.is_staff = True  
		user.save(using=self._db)
		return user


class AppUser(AbstractBaseUser, PermissionsMixin):
	user_id = models.AutoField(primary_key=True)
	email = models.EmailField(verbose_name='email address',max_length=50, unique=True)
	username = models.CharField(max_length=50)
	is_staff = models.BooleanField(default=False)
	is_superuser = models.BooleanField(default=False)
	is_active = models.BooleanField(default=True)
	picture = models.ImageField(upload_to='profile_pictures',blank=True)
	USERNAME_FIELD = 'email'
	REQUIRED_FIELDS = []
	objects = AppUserManager()
	def __str__(self):
		return self.username
	def get_picture_url(self):
		if self.picture:
			return urllib.parse.urljoin(settings.BASE_URL, self.picture.url)
		else:
			return None