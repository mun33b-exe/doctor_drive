import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:doctor_drive/main.dart';

void main() {
  testWidgets('App initialization smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: DriveDoctorApp()));

    // Verify that the app initializes with the placeholder text
    expect(find.text('Drive Doctor Initialized'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
