from fasthtml.common import *

from auth import basic_auth

app, rt = fast_app()


@app.get("/")
@basic_auth
def lander(session):
    return Container(H1("Hello, user!"), Button("Logout", hx_delete="/login"))


serve()
