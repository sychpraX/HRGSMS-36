from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    DB_HOST: str = "localhost"
    DB_PORT: int = 3306
    DB_USER: str = "hrgsms_usr"
    DB_PASSWORD: str = "password"  # Replace with your actual password
    DB_NAME: str = "hrgsms"

    JWT_SECRET: str = "change-me"
    JWT_ALGORITHM: str = "HS256"
    JWT_EXP_MINUTES: int = 1440

    APP_ENV: str = "development"

    class Config:
        env_file = ".env"

settings = Settings()
