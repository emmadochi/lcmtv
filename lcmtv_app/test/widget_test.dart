// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:lcmtv_app/main.dart';

void main() {
  testWidgets('LCMTV App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LCMTVApp());

    // Verify that the splash screen is displayed.
    expect(find.text('LCMTV'), findsOneWidget);
    expect(find.text('Video Streaming App'), findsOneWidget);
    
    // Wait for the timer to complete and pump frames
    await tester.pump(const Duration(seconds: 3));
    await tester.pump();
    
    // Verify that we've moved to the onboarding screen
    expect(find.text('Welcome to LCMTV'), findsOneWidget);
  });
}
