from django.core.exceptions import ValidationError
from django.contrib.auth import get_user_model
UserModel = get_user_model()

def custom_validation(data):
    email = data['email'].strip()
    username = data['username'].strip()
    password = data['password'].strip()
    ##
    if not email or UserModel.objects.filter(email=email).exists():
        raise ValidationError('Choose another email')

    if len(password) < 8:
        raise ValidationError('Choose another password, min 8 characters')

    # Check username
    if not username.isalnum() or not username[0].isalpha() or len(username) < 4:
        raise ValidationError('Choose another username')
    return data


def validate_email(data):
    email = data['email'].strip()
    if not email:
        raise ValidationError('an email is needed')
    return True

def validate_username(data):
    username = data['username'].strip()

    # Check if the username is alphanumeric and starts with a letter
    if not username.isalnum() or not username[0].isalpha():
        raise ValidationError('Username must be alphanumeric and start with a letter.')

    # Check if the username is at least 4 characters long
    if len(username) < 4:
        raise ValidationError('Username must be at least 4 characters long.')

    return username

def validate_password(data):
    password = data['password'].strip()
    if not password or len(password) < 7:
        raise ValidationError('Password must be at least 8 characters long')
    return True

