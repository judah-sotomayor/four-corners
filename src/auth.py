from functools import wraps

from fasthtml.common import Response
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def get_password_hash(password):
    return pwd_context.hash(password)


def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def basic_auth(f):
    @wraps(f)
    def wrapper(session, *args, **kwargs):
        if "auth" not in session:
            return Response("Not Authorized", status_code=401)
        return f(session, *args, **kwargs)

    return wrapper
