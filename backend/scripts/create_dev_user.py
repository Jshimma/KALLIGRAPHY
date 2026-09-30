from getpass import getpass

from sqlalchemy import select

from app.db.session import SessionLocal
from app.models.user import User
from app.security.passwords import hash_password


def main() -> None:
    email = input("Email: ").strip().lower()
    full_name = input("Full name: ").strip()
    password = getpass("Password: ")

    if not email or not full_name or not password:
        raise SystemExit("Email, full name, and password are required.")

    with SessionLocal() as db:
        existing = db.scalar(
            select(User).where(User.email == email)
        )

        if existing is not None:
            raise SystemExit(f"User already exists: {email}")

        user = User(
            email=email,
            password_hash=hash_password(password),
            full_name=full_name,
            role="photographer",
            is_active=True,
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        print(f"Created user id={user.id} email={user.email}")


if __name__ == "__main__":
    main()
