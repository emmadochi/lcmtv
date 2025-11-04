import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/firebase/firebase_config.dart';
import '../../main.dart';
import '../../features/auth/presentation/pages/login_screen_fixed.dart';

class FirebaseAuthWrapper extends StatelessWidget {
  const FirebaseAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseConfig.auth.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking authentication state
        if (snapshot.connectionState == ConnectionState.waiting) {
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
        
        // If there's an error, show error screen
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Authentication Error',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry authentication check
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const FirebaseAuthWrapper(),
                        ),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        
        // If user is authenticated, go to main screen
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          print('✅ User authenticated: ${user.email}');
          return const MainScreen();
        }
        
        // If user is not authenticated, go to login screen
        print('❌ User not authenticated, showing login screen');
        return const LoginScreen();
      },
    );
  }
}
