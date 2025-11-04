import 'package:flutter/material.dart';
import '../firebase/firebase_config.dart';

Future<void> navigateToAdminIfAuthorized(BuildContext context) async {
  final user = FirebaseConfig.auth.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please sign in to access Admin.')),
    );
    Navigator.of(context).pushNamed('/login');
    return;
  }

  try {
    final doc = await FirebaseConfig.firestore
        .collection('users')
        .doc(user.uid)
        .get();
    final data = doc.data() ?? {};
    final role = data['role'] as String?;
    if (role == 'admin') {
      Navigator.of(context).pushNamed('/admin');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin access required.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to verify admin access: $e')),
    );
  }
}


