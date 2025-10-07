# ☁️ Google Cloud Platform Setup Guide for LCMTV

## Prerequisites
- Google Cloud Platform account
- Firebase project created (from Firebase setup)
- Billing account enabled

## Step 1: Create GCP Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" > "New Project"
3. Enter project name: `LCTV-Backend`
4. Select organization (if applicable)
5. Click "Create"

## Step 2: Enable Required APIs

### YouTube Data API v3
1. Go to APIs & Services > Library
2. Search for "YouTube Data API v3"
3. Click on it and press "Enable"

### YouTube Analytics API
1. Search for "YouTube Analytics API"
2. Click on it and press "Enable"

### Google OAuth 2.0
1. Search for "Google OAuth2 API"
2. Click on it and press "Enable"

### Firebase APIs (if not already enabled)
1. Search for "Firebase Management API"
2. Click on it and press "Enable"

## Step 3: Create API Keys

### YouTube Data API Key
1. Go to APIs & Services > Credentials
2. Click "Create Credentials" > "API Key"
3. Name it "YouTube Data API Key"
4. Restrict it to YouTube Data API v3
5. Copy the key for use in your app

### YouTube Analytics API Key
1. Create another API Key
2. Name it "YouTube Analytics API Key"
3. Restrict it to YouTube Analytics API
4. Copy the key

## Step 4: Set Up OAuth 2.0

### Create OAuth 2.0 Client ID
1. Go to APIs & Services > Credentials
2. Click "Create Credentials" > "OAuth 2.0 Client ID"
3. Choose "Web application"
4. Add authorized redirect URIs:
   - `http://localhost:3000/auth/callback`
   - `https://yourdomain.com/auth/callback`
5. Download the JSON file

### Configure OAuth Consent Screen
1. Go to APIs & Services > OAuth consent screen
2. Choose "External" user type
3. Fill in required fields:
   - App name: LCMTV
   - User support email: your-email@domain.com
   - Developer contact: your-email@domain.com
4. Add scopes:
   - `https://www.googleapis.com/auth/youtube.readonly`
   - `https://www.googleapis.com/auth/youtube.force-ssl`
   - `https://www.googleapis.com/auth/yt-analytics.readonly`

## Step 5: Set Up Service Account

### Create Service Account
1. Go to IAM & Admin > Service Accounts
2. Click "Create Service Account"
3. Name: `lcmtv-backend-service`
4. Description: "Service account for LCMTV backend operations"
5. Click "Create and Continue"

### Assign Roles
1. Add these roles:
   - Firebase Admin
   - Cloud Functions Admin
   - Firestore Service Agent
   - Storage Admin
2. Click "Continue" > "Done"

### Create and Download Key
1. Click on the service account
2. Go to "Keys" tab
3. Click "Add Key" > "Create new key"
4. Choose JSON format
5. Download and store securely

## Step 6: Configure IAM Permissions

### Set up IAM roles for your Firebase project
1. Go to IAM & Admin > IAM
2. Find your Firebase project
3. Add the service account with these roles:
   - Firebase Admin SDK Administrator Service Agent
   - Cloud Functions Admin
   - Firestore Service Agent

## Step 7: Set Up Cloud Functions

### Enable Cloud Functions API
1. Go to Cloud Functions
2. Click "Enable API"

### Configure Cloud Functions
1. Go to Cloud Functions > Create Function
2. Name: `lcmtv-functions`
3. Runtime: Node.js 18
4. Region: us-central1 (same as Firebase)
5. Trigger: HTTP
6. Authentication: Allow unauthenticated (for now)

## Step 8: Configure Cloud Storage

### Create Storage Bucket
1. Go to Cloud Storage
2. Click "Create Bucket"
3. Name: `LCTV.appspot.com`
4. Location: us-central1
5. Storage class: Standard
6. Access control: Uniform

## Step 9: Set Up Monitoring

### Enable Cloud Monitoring
1. Go to Monitoring
2. Click "Enable Monitoring API"
3. Set up alerting policies for:
   - API quota usage
   - Error rates
   - Function execution time

### Configure Logging
1. Go to Logging
2. Set up log sinks for:
   - Cloud Functions logs
   - Firestore logs
   - API logs

## Step 10: Environment Configuration

Update your environment variables:

```env
# Google Cloud Platform
GCP_PROJECT_ID=LCTV-Backend
GCP_REGION=us-central1
GCP_SERVICE_ACCOUNT_KEY_PATH=path/to/service-account-key.json

# YouTube APIs
YOUTUBE_DATA_API_KEY=your_youtube_data_api_key
YOUTUBE_ANALYTICS_API_KEY=your_youtube_analytics_api_key

# OAuth
GOOGLE_CLIENT_ID=your_oauth_client_id
GOOGLE_CLIENT_SECRET=your_oauth_client_secret

# Firebase
FIREBASE_PROJECT_ID=LCTV
FIREBASE_REGION=us-central1
```

## Step 11: Test Configuration

### Test API Access
1. Test YouTube Data API with a simple request
2. Verify quota limits and usage
3. Test OAuth flow

### Test Firebase Integration
1. Verify Firestore access
2. Test Cloud Functions deployment
3. Verify Cloud Storage access

## Step 12: Set Up Billing Alerts

### Configure Budget Alerts
1. Go to Billing > Budgets & Alerts
2. Create budget for your project
3. Set up alerts for:
   - 50% of budget
   - 80% of budget
   - 100% of budget

## Security Best Practices

### API Key Security
- Never commit API keys to version control
- Use environment variables
- Rotate keys regularly
- Monitor usage

### Service Account Security
- Store service account keys securely
- Use least privilege principle
- Monitor service account usage
- Rotate keys regularly

### Network Security
- Use VPC for internal communication
- Configure firewall rules
- Enable DDoS protection
- Use HTTPS everywhere

## Troubleshooting

### Common Issues:

1. **API quota exceeded**
   - Check quota usage in GCP Console
   - Implement rate limiting
   - Request quota increase if needed

2. **Authentication errors**
   - Verify OAuth configuration
   - Check redirect URIs
   - Verify client ID and secret

3. **Permission denied errors**
   - Check IAM roles
   - Verify service account permissions
   - Check Firebase project access

4. **Cloud Functions not deploying**
   - Check Node.js version
   - Verify dependencies
   - Check function permissions

## Next Steps

After GCP setup is complete:
1. Deploy Cloud Functions
2. Set up monitoring and alerting
3. Configure production environment
4. Test all integrations
5. Set up CI/CD pipeline

## Support

- Google Cloud Documentation: https://cloud.google.com/docs
- YouTube API Documentation: https://developers.google.com/youtube
- Firebase Documentation: https://firebase.google.com/docs
