# 🔥 Firebase Setup Guide for LCMTV

## Prerequisites
- Google Cloud Platform account
- Firebase CLI installed (`npm install -g firebase-tools`)
- Flutter project configured

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `LCTV`
4. Enable Google Analytics (recommended)
5. Choose Analytics account or create new one
6. Click "Create project"

## Step 2: Enable Required Services

### Authentication
1. Go to Authentication > Sign-in method
2. Enable Email/Password
3. Enable Google Sign-In
4. Configure OAuth consent screen if needed

### Firestore Database
1. Go to Firestore Database
2. Click "Create database"
3. Choose "Start in test mode" (we'll update rules later)
4. Select location (choose closest to your users)

### Cloud Storage
1. Go to Storage
2. Click "Get started"
3. Choose "Start in test mode"
4. Select same location as Firestore

### Cloud Functions
1. Go to Functions
2. Click "Get started"
3. Follow the setup instructions

## Step 3: Configure Flutter App

### Android Configuration
1. In Firebase Console, go to Project Settings
2. Click "Add app" > Android
3. Enter package name: `com.lcmtv.app`
4. Download `google-services.json`
5. Place it in `android/app/` directory

### iOS Configuration
1. In Firebase Console, click "Add app" > iOS
2. Enter bundle ID: `com.lcmtv.app`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

## Step 4: Initialize Firebase in Flutter

The Firebase configuration is already set up in the code. You just need to:

1. Update the Firebase options in `lib/core/firebase/firebase_config.dart` with your actual project details:

```dart
const FirebaseOptions(
  apiKey: 'YOUR_ACTUAL_API_KEY',
  appId: 'YOUR_ACTUAL_APP_ID',
  messagingSenderId: 'YOUR_ACTUAL_SENDER_ID',
  projectId: 'LCTV', // Your actual project ID
  storageBucket: 'LCTV.appspot.com', // Your actual storage bucket
),
```

## Step 5: Deploy Firestore Rules

1. Install Firebase CLI: `npm install -g firebase-tools`
2. Login: `firebase login`
3. Initialize project: `firebase init`
4. Select Firestore and Functions
5. Deploy rules: `firebase deploy --only firestore:rules`

## Step 6: Set Up Cloud Functions

1. Navigate to functions directory: `cd functions`
2. Install dependencies: `npm install`
3. Deploy functions: `firebase deploy --only functions`

## Step 7: Configure Environment Variables

Create a `.env` file in the project root:

```env
YOUTUBE_API_KEY=your_youtube_api_key_here
FIREBASE_PROJECT_ID=LCTV
PRODUCTION=false
```

## Step 8: Test Firebase Connection

Run the app and check the console for:
- ✅ Firebase initialized successfully
- ✅ Firestore connection established
- ✅ Authentication ready

## Security Rules

The Firestore rules are already configured in `firestore.rules`:

- Users can read/write their own data
- Videos are publicly readable
- Admin-only write access for content management
- Analytics data is admin-only

## Monitoring

1. Go to Firebase Console > Analytics
2. Set up custom events for video views, user engagement
3. Configure crash reporting
4. Set up performance monitoring

## Troubleshooting

### Common Issues:

1. **Firebase not initialized**
   - Check if `google-services.json` is in the correct location
   - Verify package name matches Firebase project

2. **Authentication errors**
   - Ensure SHA-1 fingerprints are added to Firebase project
   - Check OAuth configuration

3. **Firestore permission denied**
   - Verify security rules are deployed
   - Check user authentication status

4. **Cloud Functions not working**
   - Ensure functions are deployed
   - Check Firebase project configuration

## Next Steps

After Firebase setup is complete:
1. Test user authentication
2. Test Firestore read/write operations
3. Test Cloud Functions
4. Set up monitoring and analytics
5. Configure production environment

## Support

- Firebase Documentation: https://firebase.google.com/docs
- FlutterFire Documentation: https://firebase.flutter.dev/
- Firebase Console: https://console.firebase.google.com/
