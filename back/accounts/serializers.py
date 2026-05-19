from django.forms import ValidationError
from rest_framework import serializers
from .validations import validate_username
from django.contrib.auth import get_user_model, authenticate

UserModel = get_user_model()

class UserRegisterSerializer(serializers.ModelSerializer):
	class Meta:
		model = UserModel
		fields = '__all__'
	def create(self, clean_data):
		user_obj = UserModel.objects.create_user(email=clean_data['email'], password=clean_data['password'],username=clean_data['username'])
		
		user_obj.save()
		return user_obj

class UserLoginSerializer(serializers.Serializer):
	email = serializers.EmailField()
	password = serializers.CharField()
	##
	def check_user(self, clean_data):
		user = authenticate(username=clean_data['email'], password=clean_data['password'])
		if not user:
			raise ValidationError('user not found')
		return user

class UserSerializer(serializers.ModelSerializer):
	picture_url = serializers.SerializerMethodField()

	class Meta:
		model = UserModel
		fields = ('user_id','email', 'username', 'picture_url')
	def get_picture_url(self, obj):
		return obj.get_picture_url()
class EditProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserModel
        fields = ('username', 'picture')  	
    def update(self, instance, validated_data):
        instance.username = validated_data.get('username', instance.username)
        instance.picture = validated_data.get('picture', instance.picture)
        instance.save()
        return instance