from jwt import decode, InvalidTokenError
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.contrib.auth import get_user_model

from channels.db import database_sync_to_async
from django.conf import settings
User = get_user_model()
class JWTAuthMiddleware:
    def __init__(self, inner):
        self.inner = inner

    async def __call__(self, scope, receive, send):
        print(": Middleware called")  
        headers = dict(scope['headers'])
        if b'authorization' in headers:
            print(": Authorization header found") 
            try:
                token_name, token_key = headers[b'authorization'].split()
                if token_name == b'Bearer':
                    print(": Bearer token found")  
                    user = await self.authenticate(token_key.decode())
                    if user is not None:
                        print(": User authenticated")
                        scope['user'] = user
                        return await self.inner(scope, receive, send)
                        
            except InvalidTokenError:
                print(": Invalid token")  
                await self.inner(dict(scope, user=None), receive, send)
                return
            except KeyError:
                print(": Invalid token format") 
                await self.send_error(send, "Invalid token format")
                return
        else:
            print(": No authorization header found") 
            await self.inner(dict(scope, user=None), receive, send)

    async def authenticate(self, token_key):
        print(": Authenticating user") 
        try:
            secret_key = settings.SECRET_KEY
            decoded_token = decode(token_key, secret_key, algorithms=['HS256'])
            user_id = decoded_token['user_id']
            user = await self.get_user(user_id)
            if user is not None and user.is_authenticated:
                print(": User authenticated successfully")
                
                return user
        except (InvalidTokenError, KeyError):
            print(": Authentication failed")  
            pass
        return None

    @database_sync_to_async
    def get_user(self, user_id):
        print(": Retrieving user from database") 
        try:

            return User.objects.get(user_id=user_id)
        except User.DoesNotExist:
            print(": User not found")  
            return None