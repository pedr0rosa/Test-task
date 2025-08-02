
from fastapi import FastAPI, HTTPException
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from models import Base, User
from db_connection import SQLALCHEMY_DATABASE_URL
import uvicorn  # Added import

# Create database engine and session
engine = create_engine(SQLALCHEMY_DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Create tables if they don't exist
Base.metadata.create_all(bind=engine)

app = FastAPI(redirect_slashes=False)  # Disable automatic redirects

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/users")  # Changed to POST
def create_user(user_data: dict):
    db = SessionLocal()
    try:
        # Validate required fields
        if 'name' not in user_data:
            raise HTTPException(status_code=400, detail="Name is required")
        
        # Create new user
        new_user = User(
            name=user_data['name'],
            city=user_data.get('city'),
            age=user_data.get('age')
        )
        
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        return {"message": "User created", "id": new_user.id}
    finally:
        db.close()

@app.get("/users")
def get_users():
    db = SessionLocal()
    try:
        users = db.query(User).all()
        return [
            {
                "id": user.id,
                "name": user.name,
                "city": user.city,
                "age": user.age
            } for user in users
        ]
    finally:
        db.close()
#added test
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=80)