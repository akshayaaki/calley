import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_calley/app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('CalleyApp launches with splash screen and navigates', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'calley_selected_language': 'en',
    });

    await tester.pumpWidget(const CalleyApp());
    expect(find.byType(CalleyApp), findsOneWidget);

    // Advance animation and navigation timers
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  });
}
