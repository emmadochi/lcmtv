# ☁️ Cloud Functions Setup Guide for LCMTV

## Prerequisites
- Firebase project created and configured
- Firebase CLI installed (`npm install -g firebase-tools`)
- Node.js 18+ installed
- Google Cloud Platform project set up

## Step 1: Install Firebase CLI

```bash
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login

# Verify installation
firebase --version
```

## Step 2: Initialize Firebase Functions

```bash
# Navigate to your project root
cd lctv

# Initialize Firebase (if not already done)
firebase init

# Select the following options:
# ✅ Functions: Configure a Cloud Functions directory
# ✅ Firestore: Configure security rules and indexes files
# ✅ Storage: Configure a security rules file for Cloud Storage
# ✅ Hosting: Configure files for Firebase Hosting

# When prompted:
# - Use existing project: LCTV
# - Language: JavaScript
# - ESLint: Yes
# - Install dependencies: Yes
```

## Step 3: Configure Environment Variables

### Set YouTube API Key
```bash
# Set YouTube API key for Cloud Functions
firebase functions:config:set youtube.apikey="YOUR_YOUTUBE_API_KEY"

# Verify configuration
firebase functions:config:get
```

### Alternative: Use Environment Variables
Create a `.env` file in the `functions` directory:

```env
YOUTUBE_API_KEY=your_youtube_api_key_here
FIREBASE_PROJECT_ID=LCTV
GCP_REGION=us-central1
```

## Step 4: Install Dependencies

```bash
# Navigate to functions directory
cd functions

# Install dependencies
npm install

# Install additional dependencies if needed
npm install googleapis axios cors express
```

## Step 5: Configure Firebase Project

### Update firebase.json
Ensure your `firebase.json` includes functions configuration:

```json
{
  "functions": {
    "source": "functions",
    "predeploy": [
      "npm --prefix \"$RESOURCE_DIR\" run lint",
      "npm --prefix \"$RESOURCE_DIR\" run build"
    ]
  }
}
```

### Set up Cloud Functions region
In `functions/index.js`, you can specify the region:

```javascript
exports.yourFunction = functions.region('us-central1').https.onCall(...);
```

## Step 6: Test Functions Locally

### Start Firebase Emulators
```bash
# Start all emulators
firebase emulators:start

# Or start only functions emulator
firebase emulators:start --only functions
```

### Test Functions
The emulator will start on `http://localhost:5001`

You can test functions using:
- Firebase Emulator UI: `http://localhost:4000`
- Direct HTTP calls to function endpoints
- Firebase SDK calls from your Flutter app

## Step 7: Deploy Functions

### Deploy All Functions
```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:aggregateTrendingVideos
```

### Deploy with Environment Variables
```bash
# Set environment variables
firebase functions:config:set youtube.apikey="YOUR_API_KEY"

# Deploy
firebase deploy --only functions
```

## Step 8: Set Up Scheduled Functions

### Configure Cloud Scheduler
The scheduled functions are already configured in the code:

1. **Trending Videos Aggregation**: Runs every 6 hours
2. **Live Streams Detection**: Runs every 15 minutes

### Manual Trigger (for testing)
```bash
# Trigger trending videos aggregation
firebase functions:shell
> aggregateTrendingVideos()

# Trigger live streams detection
> detectLiveStreams()
```

## Step 9: Monitor Functions

### View Function Logs
```bash
# View all function logs
firebase functions:log

# View logs for specific function
firebase functions:log --only aggregateTrendingVideos

# Follow logs in real-time
firebase functions:log --follow
```

### Monitor in Firebase Console
1. Go to Firebase Console > Functions
2. View function execution history
3. Monitor performance metrics
4. Check error rates

## Step 10: Configure Flutter App

### Add Cloud Functions SDK
Update your `pubspec.yaml`:

```yaml
dependencies:
  cloud_functions: ^5.4.4
```

### Initialize Cloud Functions in Flutter
```dart
import 'package:cloud_functions/cloud_functions.dart';

// Initialize Cloud Functions
final functions = FirebaseFunctions.instance;

// Call a function
final result = await functions.httpsCallable('trackVideoView').call({
  'videoId': 'video123',
  'watchTime': 120,
  'completionPercentage': 0.8,
  'deviceType': 'mobile',
});
```

## Step 11: Security Configuration

### Set up IAM Roles
1. Go to Google Cloud Console > IAM & Admin
2. Add the Cloud Functions service account with these roles:
   - Cloud Functions Admin
   - Firestore Service Agent
   - YouTube Data API v3 User

### Configure Function Permissions
```bash
# Set function permissions
gcloud functions add-iam-policy-binding aggregateTrendingVideos \
    --member="serviceAccount:your-service-account@project.iam.gserviceaccount.com" \
    --role="roles/cloudfunctions.invoker"
```

## Step 12: Production Configuration

### Set Production Environment Variables
```bash
# Set production API key
firebase functions:config:set youtube.apikey="PRODUCTION_API_KEY"

# Deploy to production
firebase deploy --only functions --project production
```

### Configure Monitoring
1. Set up Cloud Monitoring alerts
2. Configure error reporting
3. Set up performance monitoring
4. Configure log retention

## Step 13: Testing Functions

### Unit Testing
Create test files in `functions/test/`:

```javascript
// functions/test/index.test.js
const test = require('firebase-functions-test')();

describe('Cloud Functions', () => {
  it('should aggregate trending videos', async () => {
    // Test implementation
  });
});
```

### Integration Testing
```bash
# Run tests
npm test

# Run with coverage
npm run test:coverage
```

## Step 14: Troubleshooting

### Common Issues:

1. **Function deployment fails**
   ```bash
   # Check logs
   firebase functions:log
   
   # Check function configuration
   firebase functions:config:get
   ```

2. **YouTube API quota exceeded**
   - Check quota usage in Google Cloud Console
   - Implement rate limiting
   - Request quota increase

3. **Permission denied errors**
   - Check IAM roles
   - Verify service account permissions
   - Check Firebase project access

4. **Function timeout**
   - Increase function timeout in Firebase Console
   - Optimize function code
   - Use background functions for long operations

### Debug Functions
```bash
# Debug locally
firebase emulators:start --only functions --debug

# Check function status
firebase functions:list

# View function details
firebase functions:describe aggregateTrendingVideos
```

## Step 15: Performance Optimization

### Function Optimization
1. **Minimize cold starts**
   - Keep functions warm with scheduled triggers
   - Use connection pooling
   - Optimize dependencies

2. **Memory optimization**
   - Set appropriate memory limits
   - Use streaming for large data
   - Implement caching

3. **Timeout optimization**
   - Set appropriate timeouts
   - Use background functions for long operations
   - Implement retry logic

### Monitoring Performance
```bash
# View function metrics
firebase functions:log --only aggregateTrendingVideos --limit 100

# Check function performance
gcloud functions describe aggregateTrendingVideos --region=us-central1
```

## Step 16: CI/CD Integration

### GitHub Actions
Create `.github/workflows/deploy-functions.yml`:

```yaml
name: Deploy Cloud Functions
on:
  push:
    branches: [main]
    paths: ['functions/**']

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install -g firebase-tools
      - run: firebase deploy --only functions --token ${{ secrets.FIREBASE_TOKEN }}
```

## Step 17: Backup and Recovery

### Backup Functions
```bash
# Export function source code
firebase functions:export functions-backup/

# Backup configuration
firebase functions:config:get > functions-config.json
```

### Recovery
```bash
# Restore functions
firebase deploy --only functions

# Restore configuration
firebase functions:config:set youtube.apikey="YOUR_API_KEY"
```

## 🎉 Success Checklist

- ✅ Firebase CLI installed and configured
- ✅ Cloud Functions deployed successfully
- ✅ Environment variables set
- ✅ Scheduled functions running
- ✅ Flutter app integrated with functions
- ✅ Monitoring and logging configured
- ✅ Security rules applied
- ✅ Performance optimized
- ✅ CI/CD pipeline set up

## 📞 Support

- Firebase Functions Documentation: https://firebase.google.com/docs/functions
- Cloud Functions Documentation: https://cloud.google.com/functions/docs
- Firebase Console: https://console.firebase.google.com/
- Google Cloud Console: https://console.cloud.google.com/

## 🚀 Next Steps

After Cloud Functions setup:
1. Test all functions thoroughly
2. Set up monitoring and alerting
3. Configure production environment
4. Implement CI/CD pipeline
5. Set up backup and recovery procedures
