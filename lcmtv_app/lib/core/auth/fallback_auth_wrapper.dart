import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/firebase/firebase_config.dart';
import '../../main.dart';
import '../../features/auth/presentation/pages/login_screen.dart';

class FallbackAuthWrapper extends StatefulWidget {
  const FallbackAuthWrapper({super.key});

  @override
  State<FallbackAuthWrapper> createState() => _FallbackAuthWrapperState();
}

class _FallbackAuthWrapperState extends State<FallbackAuthWrapper> {
  bool _isLoading = true;
  bool _firebaseAvailable = false;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      // Try Firebase authentication first
      final user = FirebaseConfig.auth.currentUser;
      if (user != null) {
        setState(() {
          _firebaseAvailable = true;
          _isAuthenticated = true;
          _isLoading = false;
        });
        return;
      }

      // If no Firebase user, check SharedPreferences fallback
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      
      setState(() {
        _firebaseAvailable = false;
        _isAuthenticated = isLoggedIn;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Firebase auth check failed: $e');
      
      // Fallback to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        
        setState(() {
          _firebaseAvailable = false;
          _isAuthenticated = isLoggedIn;
          _isLoading = false;
        });
      } catch (e) {
        print('❌ SharedPreferences fallback failed: $e');
        setState(() {
          _firebaseAvailable = false;
          _isAuthenticated = false;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Checking authentication...'),
            ],
          ),
        ),
      );
    }

    if (_isAuthenticated) {
      return const MainScreen();
    } else {
      return const LoginScreenSimple();
    }
  }
}
