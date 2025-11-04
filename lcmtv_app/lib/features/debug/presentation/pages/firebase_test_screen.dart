import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/firebase_connection_test.dart';

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  Map<String, dynamic>? _testResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runFirebaseTest();
  }

  Future<void> _runFirebaseTest() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await FirebaseConnectionTest.testFirebaseConnection();
      setState(() {
        _testResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _testResults = {'error': e.toString()};
        _isLoading = false;
      });
    }
  }

  Future<void> _testFirestoreWrite() async {
    try {
      final result = await FirebaseConnectionTest.testFirestoreWrite();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Write test completed'),
          backgroundColor: result['status'] == 'success' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Write test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _testFirestoreRead() async {
    try {
      final result = await FirebaseConnectionTest.testFirestoreRead();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Read test completed: ${result['documents_found']} documents found'),
          backgroundColor: result['status'] == 'success' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Read test failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Connection Test'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runFirebaseTest,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Testing Firebase connection...'),
                ],
              ),
            )
          : _testResults == null
              ? const Center(
                  child: Text('No test results available'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overall Status
                      _buildStatusCard(
                        'Overall Status',
                        _testResults!['overall_status'] ?? 'unknown',
                        _testResults!['overall_status'] == 'success'
                            ? 'All Firebase services connected successfully'
                            : 'Some Firebase services may have issues',
                      ),
                      
                      const SizedBox(height: AppTheme.spacingL),
                      
                      // Firebase App
                      if (_testResults!['firebase_app'] != null)
                        _buildServiceCard(
                          'Firebase App',
                          _testResults!['firebase_app'],
                        ),
                      
                      // Firebase Auth
                      if (_testResults!['firebase_auth'] != null)
                        _buildServiceCard(
                          'Firebase Auth',
                          _testResults!['firebase_auth'],
                        ),
                      
                      // Firestore
                      if (_testResults!['firestore'] != null)
                        _buildServiceCard(
                          'Firestore',
                          _testResults!['firestore'],
                        ),
                      
                      // Analytics
                      if (_testResults!['analytics'] != null)
                        _buildServiceCard(
                          'Firebase Analytics',
                          _testResults!['analytics'],
                        ),
                      
                      // Crashlytics
                      if (_testResults!['crashlytics'] != null)
                        _buildServiceCard(
                          'Firebase Crashlytics',
                          _testResults!['crashlytics'],
                        ),
                      
                      // Storage
                      if (_testResults!['storage'] != null)
                        _buildServiceCard(
                          'Firebase Storage',
                          _testResults!['storage'],
                        ),
                      
                      const SizedBox(height: AppTheme.spacingXL),
                      
                      // Test Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _testFirestoreWrite,
                              icon: const Icon(Icons.edit),
                              label: const Text('Test Write'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.spacingM),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _testFirestoreRead,
                              icon: const Icon(Icons.read_more),
                              label: const Text('Test Read'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.secondaryPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatusCard(String title, String status, String description) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'success':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'partial_failure':
        statusColor = Colors.orange;
        statusIcon = Icons.warning;
        break;
      case 'failure':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor, size: 32),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.headingMedium.copyWith(
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(String title, Map<String, dynamic> data) {
    final status = data['status'] ?? 'unknown';
    final isSuccess = status == 'success';
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSuccess ? Icons.check_circle : Icons.error,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  title,
                  style: AppTheme.headingSmall.copyWith(
                    color: AppTheme.textDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingS,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSuccess ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (data['error'] != null) ...[
              const SizedBox(height: AppTheme.spacingS),
              Text(
                'Error: ${data['error']}',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.red,
                ),
              ),
            ],
            if (isSuccess && data.length > 1) ...[
              const SizedBox(height: AppTheme.spacingS),
              ...data.entries
                  .where((entry) => entry.key != 'status' && entry.key != 'error')
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${entry.key}: ${entry.value}',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textLight,
                          ),
                        ),
                      )),
            ],
          ],
        ),
      ),
    );
  }
}
