import 'package:flutter_test/flutter_test.dart';
import 'package:kalligraphy/main.dart';

void main() {
  testWidgets('KALLYGRAPHY website loads', (tester) async {
    await tester.pumpWidget(const KallygraphyApp());

    // The website has an intentionally repeating hero animation,
    // so do not use pumpAndSettle().
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('KALLYGRAPHY'), findsWidgets);
  });
}
