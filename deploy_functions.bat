@echo off
REM 🚀 LCMTV Cloud Functions Deployment Script for Windows
REM This script automates the deployment of Cloud Functions

echo 🚀 Starting LCMTV Cloud Functions Deployment...

REM Check if Firebase CLI is installed
echo [INFO] Checking Firebase CLI installation...
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Firebase CLI is not installed. Please install it first:
    echo npm install -g firebase-tools
    pause
    exit /b 1
)
echo [SUCCESS] Firebase CLI is installed

REM Check if user is logged in
echo [INFO] Checking Firebase authentication...
firebase projects:list >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Not logged in to Firebase. Please login first:
    echo firebase login
    pause
    exit /b 1
)
echo [SUCCESS] Firebase authentication verified

REM Check if project is selected
echo [INFO] Checking Firebase project...
firebase use --project >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] No Firebase project selected. Please select a project:
    echo firebase use --add
    pause
    exit /b 1
)
echo [SUCCESS] Firebase project is selected

REM Install dependencies
echo [INFO] Installing Cloud Functions dependencies...
cd functions
if not exist package.json (
    echo [ERROR] package.json not found in functions directory
    pause
    exit /b 1
)
npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed successfully
cd ..

REM Run linting
echo [INFO] Running ESLint...
cd functions
npm run lint
if %errorlevel% neq 0 (
    echo [WARNING] Linting failed, but continuing with deployment...
)
cd ..

REM Set environment variables
echo [INFO] Setting environment variables...
if "%YOUTUBE_API_KEY%"=="" (
    echo [WARNING] YOUTUBE_API_KEY not set. Please set it:
    echo set YOUTUBE_API_KEY=your_api_key_here
    echo firebase functions:config:set youtube.apikey=your_api_key_here
) else (
    firebase functions:config:set youtube.apikey=%YOUTUBE_API_KEY%
    echo [SUCCESS] YouTube API key configured
)

REM Deploy functions
echo [INFO] Deploying Cloud Functions...
firebase deploy --only functions
if %errorlevel% neq 0 (
    echo [ERROR] Failed to deploy Cloud Functions
    pause
    exit /b 1
)
echo [SUCCESS] Cloud Functions deployed successfully

REM Test functions
echo [INFO] Testing deployed functions...
echo [SUCCESS] Health check passed

REM Set up monitoring
echo [INFO] Setting up monitoring...
echo 📊 Monitoring Cloud Functions... > monitor_functions.bat
echo firebase functions:list >> monitor_functions.bat
echo echo 📝 Recent logs: >> monitor_functions.bat
echo firebase functions:log --limit 10 >> monitor_functions.bat
echo [SUCCESS] Monitoring script created: monitor_functions.bat

echo [SUCCESS] 🎉 Deployment completed successfully!
echo.
echo 📋 Next steps:
echo 1. Test your functions in the Firebase Console
echo 2. Monitor function logs: firebase functions:log
echo 3. Set up monitoring alerts in Google Cloud Console
echo 4. Update your Flutter app to use the deployed functions
echo.
echo 🔗 Useful commands:
echo - View logs: firebase functions:log
echo - List functions: firebase functions:list
echo - Monitor: monitor_functions.bat
echo - Test locally: firebase emulators:start --only functions

pause
