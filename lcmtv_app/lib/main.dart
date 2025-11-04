import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/firebase/firebase_config.dart';
import 'core/services/youtube_service.dart';
import 'core/config/app_config.dart';
import 'features/auth/presentation/pages/login_screen_fixed.dart';
import 'features/auth/presentation/pages/signup_screen_fixed.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/pages/forgot_password_screen.dart';
import 'features/auth/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/email_verification_screen.dart';
import 'features/home/presentation/pages/modern_home_screen.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/video/data/repositories/test_video_repository.dart';
import 'features/video/domain/repositories/video_repository.dart';
import 'core/services/youtube_service.dart';
import 'core/services/test_data_service.dart';
import 'features/search/presentation/pages/search_screen.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/profile/presentation/pages/edit_profile_screen.dart';
import 'features/profile/presentation/pages/watch_history_screen.dart';
import 'features/profile/presentation/pages/liked_videos_screen.dart';
import 'features/profile/presentation/pages/about_screen.dart';
import 'features/trending/presentation/pages/trending_screen.dart';
import 'features/debug/presentation/pages/firebase_test_screen.dart';
import 'features/debug/presentation/pages/auth_audit_screen.dart';
import 'features/admin/presentation/pages/admin_dashboard.dart';
import 'features/admin/data/repositories/admin_repository_impl.dart';
import 'features/admin/presentation/cubit/admin_cubit.dart';
import 'core/services/firestore_test_data_service.dart';
import 'shared/widgets/logo_widget.dart';
import 'core/auth/firebase_auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Firebase
    await FirebaseConfig.initialize();
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization failed: $e');
    print('⚠️ Continuing without Firebase - some features may not work');
  }
  
  try {
    // Initialize YouTube service
    YouTubeService.initialize(apiKey: AppConfig.youtubeApiKey);
    print('✅ YouTube service initialized');
  } catch (e) {
    print('❌ YouTube service initialization failed: $e');
  }
  
  try {
    // Initialize SharedPreferences
    await SharedPreferences.getInstance();
    print('✅ SharedPreferences initialized');
  } catch (e) {
    print('❌ SharedPreferences initialization failed: $e');
  }
  
  // Initialize Firestore test data (optional)
  if (AppConfig.seedFirestoreOnStartup) {
    try {
      await FirestoreTestDataService.initializeTestData();
      print('✅ Firestore test data initialized');
    } catch (e) {
      print('❌ Firestore test data initialization failed: $e');
    }
  }
  
  runApp(const LCMTVApp());
}

class LCMTVApp extends StatelessWidget {
  const LCMTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LCMTV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
              home: const MainScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
              child: const LoginScreen(),
            ),
        '/signup': (context) => BlocProvider<AuthCubit>(
              create: (context) => AuthCubit(),
              child: const SignupScreen(),
            ),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/email-verification': (context) => EmailVerificationScreen(
          email: 'user@example.com', // This should come from the signup process
        ),
        '/main': (context) => const MainScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/watch-history': (context) => const WatchHistoryScreen(),
        '/liked-videos': (context) => const LikedVideosScreen(),
                '/about': (context) => const AboutScreen(),
                '/firebase-test': (context) => const FirebaseTestScreen(),
                '/auth-audit': (context) => const AuthAuditScreen(),
                '/admin': (context) => BlocProvider(
                  create: (context) => AdminCubit(
                    adminRepository: AdminRepositoryImpl(),
                  ),
                  child: const AdminDashboard(),
                ),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    const LargeLogoWidget(
                      width: 120,
                      height: 120,
                      showText: false,
                    ),
                    const SizedBox(height: 24),
                    // App Name
                    Text(
                      'LCMTV',
                      style: AppTheme.headingLarge.copyWith(
                        color: AppTheme.primaryPurple,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
            Text(
                      'Video Streaming App',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading Indicator
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryPurple,
                        ),
                      ),
            ),
          ],
        ),
      ),
      ),
            );
          },
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize test video repository with real-time data
    final videoRepository = TestVideoRepository();
    
    // Start real-time data updates
    TestDataService().startRealTimeUpdates();
    
            _screens = [
              const ModernHomeScreen(),
              const TrendingScreen(),
              const SearchScreen(),
              const ProfileScreen(),
            ];
  }

  @override
  void dispose() {
    // Stop real-time data updates when screen is disposed
    TestDataService().stopRealTimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.backgroundWhite,
        selectedItemColor: AppTheme.primaryPurple,
        unselectedItemColor: AppTheme.textLight,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Screens are now imported from their respective feature modules