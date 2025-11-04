import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/firebase/firebase_config.dart';
import '../../../../core/services/cloud_functions_service.dart';

// ============================================================================
// EVENTS
// ============================================================================

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const SignupRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class GoogleSignInRequested extends AuthEvent {
  const GoogleSignInRequested();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class EmailVerificationRequested extends AuthEvent {
  const EmailVerificationRequested();
}

// ============================================================================
// STATES
// ============================================================================

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthEmailVerificationSent extends AuthState {
  final String email;

  const AuthEmailVerificationSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}

// ============================================================================
// CUBIT
// ============================================================================

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthCubit({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn(),
       super(AuthInitial()) {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  void _onAuthStateChanged(User? user) {
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    print('🔵 AuthCubit.login called with email: $email');
    emit(AuthLoading());
    
    try {
      print('🔵 Attempting Firebase signInWithEmailAndPassword');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        print('🔵 Firebase authentication successful');
        // Track login analytics
        await CloudFunctionsService.trackUserLogin();
        
        emit(AuthAuthenticated(user: credential.user!));
      } else {
        print('🔵 Firebase authentication failed - no user');
        emit(const AuthError(message: 'Login failed'));
      }
    } on FirebaseAuthException catch (e) {
      print('🔵 FirebaseAuthException: ${e.message}');
      emit(AuthError(message: _getAuthErrorMessage(e)));
    } catch (e) {
      print('🔵 Unexpected error: $e');
      emit(AuthError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String displayName,
  }) async {
    emit(AuthLoading());
    
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Update display name
        await credential.user!.updateDisplayName(displayName);
        
        // Send email verification
        await credential.user!.sendEmailVerification();
        
        // Track signup analytics
        await CloudFunctionsService.trackUserEngagement(
          action: 'user_signup',
          parameters: {
            'email': email,
            'displayName': displayName,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        
        emit(AuthEmailVerificationSent(email: email));
      } else {
        emit(const AuthError(message: 'Signup failed'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getAuthErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'An unexpected error occurred: $e'));
    }
  }

  Future<void> googleSignIn() async {
    print('🔵 AuthCubit.googleSignIn called');
    emit(AuthLoading());
    
    try {
      print('🔵 Attempting Google Sign-In');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('🔵 Google Sign-In cancelled by user');
        emit(AuthUnauthenticated());
        return;
      }

      print('🔵 Google Sign-In successful, getting authentication');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔵 Attempting Firebase signInWithCredential');
      final userCredential = await _auth.signInWithCredential(credential);
      
      if (userCredential.user != null) {
        print('🔵 Firebase Google authentication successful');
        // Track Google sign-in analytics
        await CloudFunctionsService.trackUserEngagement(
          action: 'google_signin',
          parameters: {
            'email': userCredential.user!.email,
            'displayName': userCredential.user!.displayName,
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
        
        emit(AuthAuthenticated(user: userCredential.user!));
      } else {
        print('🔵 Firebase Google authentication failed - no user');
        emit(const AuthError(message: 'Google sign-in failed'));
      }
    } catch (e) {
      print('🔵 Unexpected error in Google Sign-In: $e');
      emit(AuthError(message: 'Google sign-in failed: $e'));
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      
      // Track logout analytics
      await CloudFunctionsService.trackUserLogout();
      
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed: $e'));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(AuthLoading());
    
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthPasswordResetSent(email: email));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getAuthErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: 'Password reset failed: $e'));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        emit(AuthEmailVerificationSent(email: user.email!));
      }
    } catch (e) {
      emit(AuthError(message: 'Email verification failed: $e'));
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.delete();
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: 'Account deletion failed: $e'));
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not allowed.';
      case 'invalid-credential':
        return 'Invalid credentials.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
