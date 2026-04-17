// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:book_me_mobile_app/app/app.dart';

void main() {
  testWidgets('Shows role selection as initial screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BookMeApp());

    expect(find.text('Sign in to Book Me'), findsOneWidget);
    expect(find.text('Phone login (UI skeleton)'), findsOneWidget);
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Role'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
  });
}
