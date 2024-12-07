from django.contrib.auth import get_user_model, login, logout
from django.contrib.auth.tokens import default_token_generator
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from django.utils.encoding import force_bytes
from django.core.mail import send_mail
from django.urls import reverse
from rest_framework_simplejwt.authentication import JWTAuthentication

from rest_framework_simplejwt.tokens import RefreshToken
from rest_auth.views import PasswordResetView
from django.conf import settings
from rest_framework.authentication import SessionAuthentication
from rest_framework.views import APIView
from rest_framework.response import Response
from .serializers import UserRegisterSerializer, UserLoginSerializer, UserSerializer,EditProfileSerializer
from rest_framework import permissions, status
from .validations import custom_validation, validate_email, validate_password
from django.core.mail import send_mail
from pfe.settings import EMAIL_HOST_USER
from rest_framework.permissions import IsAuthenticated
User=get_user_model()
from rest_framework_simplejwt.tokens import RefreshToken


class UserRegister(APIView):
	permission_classes = (permissions.AllowAny,)
	def post(self, request):
		clean_data = custom_validation(request.data)
		serializer = UserRegisterSerializer(data=clean_data)
		if serializer.is_valid(raise_exception=True):
			user = serializer.create(clean_data)
			if user:
				return Response(serializer.data, status=status.HTTP_201_CREATED)
		return Response(clean_data,status=status.HTTP_400_BAD_REQUEST)


class UserLogin(APIView):
    permission_classes = (permissions.AllowAny,)
    authentication_classes = (SessionAuthentication,)

    def post(self, request):
        data = request.data
        assert validate_email(data)
        assert validate_password(data)
        serializer = UserLoginSerializer(data=data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.check_user(data)
            login(request, user)
            # Generate JWT tokens
            refresh = RefreshToken.for_user(user)
            return Response({
                'refresh': str(refresh),
                'access': str(refresh.access_token),
            }, status=status.HTTP_200_OK)


class UserLogout(APIView):
	permission_classes = (permissions.AllowAny,)
	authentication_classes = ()
	def post(self, request):
		logout(request)
		return Response(status=status.HTTP_200_OK)


class UserView(APIView):
	permission_classes = (permissions.IsAuthenticated,)
	authentication_classes = (JWTAuthentication,SessionAuthentication)
	def get(self, request):
		serializer = UserSerializer(request.user)
		return Response({'user': serializer.data}, status=status.HTTP_200_OK)
class PasswordReset(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        email = request.data.get('email')
        if email:
            User = get_user_model()
            try:
                user = User.objects.get(email=email)
            except User.DoesNotExist:
                user = None
            if user:
                uid = urlsafe_base64_encode(force_bytes(user.pk))
                token = default_token_generator.make_token(user)
                reset_url = reverse('password_reset_confirm', kwargs={'uidb64': uid, 'token': token})
                reset_link = f'{settings.BASE_URL}{reset_url}'
                subject = 'Password Reset'
                message = f'Click the following link to reset your password: {reset_link}'
                from_email = settings.DEFAULT_FROM_EMAIL
                to_email = [email]
                send_mail(subject, message, from_email, to_email)
                return Response({'message': 'Password reset email has been sent','deep_link': reset_link}, status=status.HTTP_200_OK)
        return Response({'error': 'User with this email does not exist'}, status=status.HTTP_400_BAD_REQUEST)
class GetAllUsers(APIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]
    def get(self, request):
        users = User.objects.exclude(username=self.request.user.username)
        serializer = self.serializer_class(users, many=True)
        return Response(data=serializer.data, status=status.HTTP_200_OK) 
class EditProfile(APIView):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (JWTAuthentication, SessionAuthentication)
    def put(self, request):
        serializer = EditProfileSerializer(request.user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class SearchUserView(APIView):
    permission_classes = (permissions.IsAuthenticated,)
    authentication_classes = (JWTAuthentication,SessionAuthentication)
    def get(self, request):
        username = request.query_params.get('username', None)
        if username:
            users = User.objects.filter(username__icontains=username)
            if users.exists():
                serializer = UserSerializer(users, many=True)
                return Response(serializer.data)
            else:
                return Response({'message': 'No users found with the provided username'}, status=status.HTTP_404_NOT_FOUND)
        else:
            return Response({'error': 'Please provide a username query parameter'}, status=status.HTTP_400_BAD_REQUEST)   
