import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/firestore_test_data_service.dart';

class TestDataManagementScreen extends StatefulWidget {
  const TestDataManagementScreen({super.key});

  @override
  State<TestDataManagementScreen> createState() => _TestDataManagementScreenState();
}

class _TestDataManagementScreenState extends State<TestDataManagementScreen> {
  bool _isLoading = false;
  Map<String, int> _statistics = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final stats = await FirestoreTestDataService.getDataStatistics();
      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to load statistics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        title: const Text('Test Data Management'),
        backgroundColor: AppTheme.primaryPurple,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistics Cards
                  _buildStatisticsSection(),
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Test Data Actions
                  _buildTestDataActions(),
                  const SizedBox(height: AppTheme.spacingXL),
                  
                  // Data Management Actions
                  _buildDataManagementActions(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Firestore Data Statistics',
          style: AppTheme.headingMedium.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Categories',
                _statistics['categories']?.toString() ?? '0',
                Icons.category,
                Colors.blue,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildStatCard(
                'Content',
                _statistics['content']?.toString() ?? '0',
                Icons.video_library,
                Colors.green,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: _buildStatCard(
                'Users',
                _statistics['users']?.toString() ?? '0',
                Icons.people,
                Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              value,
              style: AppTheme.headingLarge.copyWith(
                color: AppTheme.textDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestDataActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Test Data Actions',
          style: AppTheme.headingMedium.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        _buildActionCard(
          'Initialize Test Data',
          'Create sample categories, content, and users in Firestore',
          Icons.add_circle,
          Colors.green,
          _initializeTestData,
        ),
        const SizedBox(height: AppTheme.spacingM),
        _buildActionCard(
          'Add Sample Content',
          'Add a new sample video to test content creation',
          Icons.video_call,
          Colors.blue,
          _addSampleContent,
        ),
        const SizedBox(height: AppTheme.spacingM),
        _buildActionCard(
          'Refresh Statistics',
          'Update the data statistics display',
          Icons.refresh,
          Colors.orange,
          _loadStatistics,
        ),
      ],
    );
  }

  Widget _buildDataManagementActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Management',
          style: AppTheme.headingMedium.copyWith(
            color: AppTheme.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        _buildActionCard(
          'Clear All Test Data',
          'Remove all test data from Firestore (use with caution)',
          Icons.delete_forever,
          Colors.red,
          _clearTestData,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingS),
                    Text(
                      description,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textLight,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initializeTestData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirestoreTestDataService.initializeTestData();
      await _loadStatistics();
      _showSuccessSnackBar('Test data initialized successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to initialize test data: $e');
    }
  }

  Future<void> _addSampleContent() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await FirestoreTestDataService.addSampleContent();
      await _loadStatistics();
      _showSuccessSnackBar('Sample content added successfully!');
    } catch (e) {
      _showErrorSnackBar('Failed to add sample content: $e');
    }
  }

  Future<void> _clearTestData() async {
    final confirmed = await _showConfirmDialog(
      'Clear All Test Data',
      'Are you sure you want to delete all test data from Firestore? This action cannot be undone.',
    );

    if (confirmed) {
      setState(() {
        _isLoading = true;
      });

      try {
        await FirestoreTestDataService.clearTestData();
        await _loadStatistics();
        _showSuccessSnackBar('Test data cleared successfully!');
      } catch (e) {
        _showErrorSnackBar('Failed to clear test data: $e');
      }
    }
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
      ),
    );
  }
}
