import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agrobiz_simulator/main.dart';

void main() {
  testWidgets('App loads and shows title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgroBizApp());

    // Verify that our app bar shows the title
    expect(find.text('AgroBiz Simulator'), findsOneWidget);
    
    // Verify input tabs (Mobile) or split view text
    // Just simple smoke test
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
