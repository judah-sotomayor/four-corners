from fastlite import database

from config import FCR_DATABASE_FILE

db = database(FCR_DATABASE_FILE)


users = db.t.users

if users not in db.t:
    users.create({"email": str, "password": str}, pk="email")

User = users.dataclass()
