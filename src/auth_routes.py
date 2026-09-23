from fasthtml.common import *

from auth import get_password_hash, verify_password
from database import User, users
from main import app


def LoginForm(btn_text, target):
    return Form(
        Input(id="email", type="email", placeholder="Email", required=True),
        Input(id="password", type="password", placeholder="Password", required=True),
        Button(btn_text, type="submit"),
        Span(id="error", style="color:red"),
        hx_post=target,
        hx_target="#error",
    )


@app.get("/register")
def registration_page():
    return Container(
        Article(
            H1("Register"),
            LoginForm("Register", "/register"),
            Hr(),
            P("Already have an account? ", A("Login", href="/login")),
        )
    )


@app.post("/register")
def register_user(email: str, password: str):

    try:
        users[email]
        return "User already exists"
    except NotFoundError:
        users.insert(User(email=email, password=get_password_hash(password)))
        return HttpHeader("HX-Redirect", "/login")


@app.get("/login")
def login_page():
    return Container(
        Article(
            H1("Login"),
            LoginForm("Login", "/login"),
            Hr(),
            P("Don't have an account? ", A("Register", href="/register")),
        )
    )


@app.post("/login")
def create_session(session, email: str, password: str):
    try:
        user = users[email]
    except NotFoundError:
        return "Email or password are incorrect"

    if not verify_password(password, user.password):
        return "Email or password are incorrect"

    session["auth"] = user.email

    return HttpHeader("HX-Redirect", "/")


@app.delete("/login")
def destroy_session(session):
    del session["auth"]
    return HttpHeader("HX-Redirect", "/login")
