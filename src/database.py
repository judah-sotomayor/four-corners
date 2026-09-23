from fastlite import database

from config import SBS_DATABASE_FILE

db = database(SBS_DATABASE_FILE)


users = db.t.users

if users not in db.t:
    users.create({"email": str, "password": str}, pk="email")

User = users.dataclass()
