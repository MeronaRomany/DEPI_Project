import 'package:depi_project/App/my_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app widget tree boots successfully.
    expect(find.byType(MyApp), findsOneWidget);
  });
}
