import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/auth/admin_guard.dart';

class FirestoreConnectionStatus extends StatefulWidget {
  const FirestoreConnectionStatus({super.key});

  @override
  State<FirestoreConnectionStatus> createState() => _FirestoreConnectionStatusState();
}

class _FirestoreConnectionStatusState extends State<FirestoreConnectionStatus> {
  bool _isConnected = false;
  bool _isLoading = true;
  String _statusMessage = 'Checking connection...';
  int _documentCount = 0;

  @override
  void initState() {
    super.initState();
    _testFirestoreConnection();
  }

  Future<void> _testFirestoreConnection() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = 'Testing Firestore connection...';
      });

      // Test basic connection
      final firestore = FirebaseFirestore.instance;
      
      // Read from publicly readable collections per security rules
      final videosSnapshot = await firestore.collection('videos').limit(1).get();
      final categoriesSnapshot = await firestore.collection('categories').limit(1).get();
      final trendingSnapshot = await firestore.collection('trending').limit(1).get();

      final totalDocs = videosSnapshot.docs.length + 
                       categoriesSnapshot.docs.length + 
                       trendingSnapshot.docs.length;

      setState(() {
        _isConnected = true;
        _isLoading = false;
        _statusMessage = 'Firestore connected successfully!';
        _documentCount = totalDocs;
      });

    } on FirebaseException catch (e) {
      final message = e.code == 'permission-denied'
          ? 'Permission denied. Sign in or adjust Firestore rules to allow reads.'
          : e.message ?? e.code;
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _statusMessage = 'Firestore connection failed: $message';
        _documentCount = 0;
      });
    } catch (e) {
      setState(() {
        _isConnected = false;
        _isLoading = false;
        _statusMessage = 'Firestore connection failed: $e';
        _documentCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingL),
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: _isConnected ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: _isConnected ? Colors.green.shade200 : Colors.red.shade200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isConnected ? Icons.cloud_done : Icons.cloud_off,
                color: _isConnected ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Text(
                'Firestore Status',
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const Spacer(),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingS),
          Text(
            _statusMessage,
            style: AppTheme.bodyMedium.copyWith(
              color: _isConnected ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
          if (_isConnected) ...[
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Documents found: $_documentCount',
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textLight,
              ),
            ),
          ],
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _testFirestoreConnection,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Test Connection'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingS,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              if (_isConnected)
                ElevatedButton.icon(
                  onPressed: () => navigateToAdminIfAuthorized(context),
                  icon: const Icon(Icons.admin_panel_settings, size: 16),
                  label: const Text('Open Admin'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                      vertical: AppTheme.spacingS,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}












