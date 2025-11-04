import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/firebase/firebase_config.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../main.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseConfig.auth.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        // If user is authenticated, go to main screen
        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }
        
        // If user is not authenticated, go to login screen
        return const LoginScreenSimple();
      },
    );
  }
}
