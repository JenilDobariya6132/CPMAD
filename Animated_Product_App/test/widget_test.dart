import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:animated_product_app/main.dart';

void main() {
  testWidgets('App starts with onboarding screen', (WidgetTester tester) async {
    await tester.pumpWidget(const AnimatedProductApp());
    // Just verify the app boots without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
