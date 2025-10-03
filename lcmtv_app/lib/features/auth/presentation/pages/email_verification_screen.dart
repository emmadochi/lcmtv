import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback? onVerified;
  final VoidCallback? onResend;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    this.onVerified,
    this.onResend,
  });

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  
  bool _isResending = false;
  bool _isVerified = false;
  int _resendCount = 0;
  int _countdown = 0;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _resendVerification() async {
    if (_countdown > 0) return;

    setState(() {
      _isResending = true;
    });

    // Simulate resend process
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isResending = false;
      _resendCount++;
      _countdown = 60; // 60 seconds cooldown
    });

    // Start countdown
    _startCountdown();

    // Call the resend callback
    widget.onResend?.call();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Verification email sent successfully'),
          backgroundColor: AppTheme.successGreen,
        ),
      );
    }
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          timer.cancel();
        }
      }
    });
  }

  void _checkVerification() async {
    // Simulate checking verification status
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isVerified = true;
      });

      // Call the verified callback
      widget.onVerified?.call();

      // Navigate to main app
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }

  void _changeEmail() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Verification Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _isVerified 
                              ? AppTheme.successGreen.withValues(alpha: 0.1)
                              : AppTheme.primaryPurple.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isVerified ? Icons.check_circle : Icons.email,
                          size: 60,
                          color: _isVerified ? AppTheme.successGreen : AppTheme.primaryPurple,
                        ),
                      ),
                      
                      const SizedBox(height: AppTheme.spacingXXL),
                      
                      // Title
                      Text(
                        _isVerified ? 'Email Verified!' : 'Check Your Email',
                        style: AppTheme.headingLarge.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: AppTheme.spacingM),
                      
                      // Description
                      Text(
                        _isVerified 
                            ? 'Your email has been successfully verified. You can now access all features.'
                            : 'We\'ve sent a verification link to',
                        style: AppTheme.bodyLarge.copyWith(
                          color: AppTheme.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      if (!_isVerified) ...[
                        const SizedBox(height: AppTheme.spacingS),
                        Text(
                          widget.email,
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.primaryPurple,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      
                      const SizedBox(height: AppTheme.spacingXL),
                      
                      if (!_isVerified) ...[
                        // Resend Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _countdown > 0 ? null : _resendVerification,
                            child: _isResending
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.backgroundWhite,
                                      ),
                                    ),
                                  )
                                : Text(
                                    _countdown > 0 
                                        ? 'Resend in ${_countdown}s' 
                                        : 'Resend Verification Email',
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Check Verification Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _checkVerification,
                            child: const Text('I\'ve Verified My Email'),
                          ),
                        ),
                        
                        const SizedBox(height: AppTheme.spacingL),
                        
                        // Change Email Button
                        TextButton(
                          onPressed: _changeEmail,
                          child: const Text('Change Email Address'),
                        ),
                      ] else ...[
                        // Success State
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingL),
                          decoration: BoxDecoration(
                            color: AppTheme.successGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            border: Border.all(
                              color: AppTheme.successGreen.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 48,
                                color: AppTheme.successGreen,
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              Text(
                                'Verification Complete!',
                                style: AppTheme.headingSmall.copyWith(
                                  color: AppTheme.successGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingS),
                              Text(
                                'Welcome to LCMTV! You can now start watching amazing videos.',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: AppTheme.spacingXL),
                      
                      // Help Text
                      if (!_isVerified)
                        Text(
                          'Didn\'t receive the email? Check your spam folder or try resending.',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textLight,
                          ),
                          textAlign: TextAlign.center,
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

