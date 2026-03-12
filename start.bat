@echo off
:: BioSignal Scanner — one-command Docker start (Windows)

:: ── 1. Check Docker is installed ─────────────────────────────────────────────
docker --version >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Docker is not installed.
    echo Download Docker Desktop from: https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Docker is installed but not running.
    echo Please start Docker Desktop and try again.
    echo.
    pause
    exit /b 1
)

:: ── 2. Check .env exists ──────────────────────────────────────────────────────
if not exist ".env" (
    echo.
    echo No .env file found. Creating from template...
    copy .env.example .env
    echo.
    echo ACTION REQUIRED:
    echo     Open .env and set your ANTHROPIC_API_KEY, then run this script again.
    echo.
    echo     notepad .env
    echo.
    pause
    exit /b 1
)

findstr /c:"your_anthropic_api_key_here" .env >nul 2>&1
if not errorlevel 1 (
    echo.
    echo ACTION REQUIRED:
    echo     Your ANTHROPIC_API_KEY in .env has not been set yet.
    echo     Open .env, replace 'your_anthropic_api_key_here' with your real key, then run again.
    echo.
    pause
    exit /b 1
)

:: ── 3. Start everything ───────────────────────────────────────────────────────
echo.
echo Starting BioSignal Scanner...
echo First build takes 5-10 minutes (TensorFlow + DeepFace are large).
echo Subsequent starts take ~30 seconds.
echo.

docker compose up --build

echo.
echo ─────────────────────────────────────────
echo   App:  http://localhost:3000
echo   API:  http://localhost:8000
echo ─────────────────────────────────────────
pause
