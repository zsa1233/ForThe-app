// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:simple_app/main.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TerraApp());
    await tester.pump(const Duration(seconds: 1)); // Wait for animations

    // Verify that the navigation appears
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    
    // Dispose all pending timers
    await tester.pumpAndSettle();
  });
}
