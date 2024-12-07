from rest_framework.views import exception_handler
from rest_framework.exceptions import APIException
from rest_framework.response import Response
from django.db.utils import IntegrityError
from rest_framework import status

def api_exception_handler(exc, context):
    response = exception_handler(exc, context)

    if response:
        return response
    elif isinstance(exc, IntegrityError):
        data = {'detail': str(exc)}
        return Response(data, status=status.HTTP_422_UNPROCESSABLE_ENTITY)
class PasswordException(APIException):
    status_code = 400
    default_detail = "Enter another."
    default_code = "wrong_password_format"