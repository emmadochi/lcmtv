const functions = require('firebase-functions');
const admin = require('firebase-admin');

// Initialize Firebase Admin
admin.initializeApp();

// ============================================================================
// HEALTH CHECK
// ============================================================================

/**
 * Health check endpoint
 */
exports.healthCheck = functions.https.onRequest((req, res) => {
  res.status(200).json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0',
    services: {
      firestore: 'connected',
      youtube: 'configured',
      analytics: 'enabled',
    },
  });
});

// ============================================================================
// USER MANAGEMENT
// ============================================================================

/**
 * Creates user profile when user signs up
 */
exports.createUserProfile = functions.auth.user().onCreate(async (user) => {
  console.log(`🔄 Creating user profile for ${user.uid}`);
  
  try {
    const userProfile = {
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLoginAt: admin.firestore.FieldValue.serverTimestamp(),
      role: 'user',
      preferences: {
        language: 'en',
        region: 'US',
        notificationsEnabled: true,
        autoPlayEnabled: true,
        videoQuality: 'auto',
        interests: [],
        darkModeEnabled: false,
      },
      profile: {
        firstName: user.displayName?.split(' ')[0] || '',
        lastName: user.displayName?.split(' ').slice(1).join(' ') || '',
        bio: '',
        location: '',
        gender: 'not_specified',
        socialLinks: [],
      },
    };
    
    await admin.firestore()
      .collection('users')
      .doc(user.uid)
      .set(userProfile);
    
    console.log(`✅ User profile created for ${user.uid}`);
    
  } catch (error) {
    console.error(`❌ Error creating user profile for ${user.uid}:`, error);
  }
});

// ============================================================================
// VIDEO ANALYTICS
// ============================================================================

/**
 * Tracks video view and updates analytics
 */
exports.trackVideoView = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { videoId, watchTime, completionPercentage, deviceType } = data;
  
  if (!videoId || !watchTime || completionPercentage === undefined) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required parameters');
  }
  
  try {
    const userId = context.auth.uid;
    const today = new Date().toISOString().split('T')[0];
    
    // Add to user's watch history
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('watchHistory')
      .add({
        videoId,
        watchTime: parseInt(watchTime),
        completionPercentage: parseFloat(completionPercentage),
        deviceType: deviceType || 'mobile',
        watchedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    // Update video analytics
    await admin.firestore()
      .collection('analytics')
      .doc(today)
      .collection('videoViews')
      .add({
        videoId,
        userId,
        watchTime: parseInt(watchTime),
        completionPercentage: parseFloat(completionPercentage),
        deviceType: deviceType || 'mobile',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`✅ Video view tracked for user ${userId}, video ${videoId}`);
    return { success: true };
    
  } catch (error) {
    console.error('❌ Error tracking video view:', error);
    throw new functions.https.HttpsError('internal', 'Failed to track video view');
  }
});

/**
 * Tracks user engagement events
 */
exports.trackUserEngagement = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { action, parameters } = data;
  
  if (!action) {
    throw new functions.https.HttpsError('invalid-argument', 'Action is required');
  }
  
  try {
    const userId = context.auth.uid;
    const today = new Date().toISOString().split('T')[0];
    
    await admin.firestore()
      .collection('analytics')
      .doc(today)
      .collection('userEngagement')
      .add({
        userId,
        action,
        parameters: parameters || {},
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });
    
    console.log(`✅ User engagement tracked: ${action} for user ${userId}`);
    return { success: true };
    
  } catch (error) {
    console.error('❌ Error tracking user engagement:', error);
    throw new functions.https.HttpsError('internal', 'Failed to track user engagement');
  }
});

// ============================================================================
// CONTENT MANAGEMENT
// ============================================================================

/**
 * Adds video to user's liked videos
 */
exports.addLikedVideo = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { videoId, note } = data;
  
  if (!videoId) {
    throw new functions.https.HttpsError('invalid-argument', 'Video ID is required');
  }
  
  try {
    const userId = context.auth.uid;
    
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('likedVideos')
      .doc(videoId)
      .set({
        videoId,
        userId,
        likedAt: admin.firestore.FieldValue.serverTimestamp(),
        note: note || '',
      });
    
    console.log(`✅ Video ${videoId} added to liked videos for user ${userId}`);
    return { success: true };
    
  } catch (error) {
    console.error('❌ Error adding liked video:', error);
    throw new functions.https.HttpsError('internal', 'Failed to add liked video');
  }
});

/**
 * Removes video from user's liked videos
 */
exports.removeLikedVideo = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  const { videoId } = data;
  
  if (!videoId) {
    throw new functions.https.HttpsError('invalid-argument', 'Video ID is required');
  }
  
  try {
    const userId = context.auth.uid;
    
    await admin.firestore()
      .collection('users')
      .doc(userId)
      .collection('likedVideos')
      .doc(videoId)
      .delete();
    
    console.log(`✅ Video ${videoId} removed from liked videos for user ${userId}`);
    return { success: true };
    
  } catch (error) {
    console.error('❌ Error removing liked video:', error);
    throw new functions.https.HttpsError('internal', 'Failed to remove liked video');
  }
});