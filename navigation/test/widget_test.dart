import 'package:flutter_test/flutter_test.dart';

import 'package:navigation_demo/main.dart';

void main() {
  testWidgets('Navigation Demo App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NavigationDemoApp());

    // Verify that the Home Screen loads with the navigation heading
    expect(find.text('Navigation\nMaster Class'), findsOneWidget);
  });
}
