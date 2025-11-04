# 🎬 YouTube API Setup - Production Ready

## 📋 **Step-by-Step YouTube API Configuration**

### 1. **Get YouTube Data API Key**

1. **Go to Google Cloud Console**: https://console.cloud.google.com/
2. **Create New Project** or select existing project
3. **Enable YouTube Data API v3**:
   - Go to "APIs & Services" > "Library"
   - Search for "YouTube Data API v3"
   - Click "Enable"

4. **Create API Key**:
   - Go to "APIs & Services" > "Credentials"
   - Click "Create Credentials" > "API Key"
   - Copy the generated API key

### 2. **Configure API Key in Backend**

Update your `.env` file with the YouTube API key:

```bash
# Add this to your .env file
YOUTUBE_API_KEY="YOUR_ACTUAL_YOUTUBE_API_KEY_HERE"
```

### 3. **Test YouTube API Integration**

Run the test script to verify API key works:

```bash
cd lcmtv-backend
node test-youtube-api.js
```

### 4. **API Quota Management**

- **Daily Quota**: 10,000 units per day
- **Search**: 100 units per request
- **Video Details**: 1 unit per request
- **Trending**: 1 unit per request

### 5. **Production Considerations**

- **Rate Limiting**: Implement proper rate limiting
- **Caching**: Cache popular videos to reduce API calls
- **Error Handling**: Handle quota exceeded errors gracefully
- **Monitoring**: Monitor API usage and costs

## 🔧 **Backend Configuration Updates**

### Update Environment Variables

```bash
# Production Environment
NODE_ENV=production
YOUTUBE_API_KEY=your_actual_api_key
DATABASE_URL=postgresql://lcmtv_user:lcmtv_password@localhost:5432/lcmtv_db
JWT_SECRET=your-super-secret-jwt-key
PORT=3000
```

### Update YouTube Service

The YouTube service is already configured to use the API key from environment variables.

## 🚀 **Next Steps**

1. **Get YouTube API Key** (5 minutes)
2. **Update .env file** (2 minutes)
3. **Test API integration** (3 minutes)
4. **Deploy to production** (10 minutes)

## 📊 **Expected Results**

After configuration, the app will:
- ✅ Load real trending videos from YouTube
- ✅ Search real videos from YouTube
- ✅ Display actual video thumbnails and metadata
- ✅ Show real view counts and like counts
- ✅ Provide actual video durations

## 🔒 **Security Notes**

- Keep your API key secure
- Use environment variables only
- Never commit API keys to version control
- Consider using API key restrictions in production
