import 'package:flutter_test/flutter_test.dart';
import 'package:kalligraphy/main.dart';

void main() {
  testWidgets('KALLIGRAPHY website loads', (tester) async {
    await tester.pumpWidget(const KalligraphyApp());
    await tester.pumpAndSettle();

    expect(find.text('KALLIGRAPHY'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Stories worth'), findsOneWidget);
  });
}
