import 'package:flutter_test/flutter_test.dart';
import 'package:kalligraphy/main.dart';

void main() {
  testWidgets('KALLYGRAPHY website loads', (tester) async {
    await tester.pumpWidget(const KallygraphyApp());
    await tester.pumpAndSettle();

    expect(find.text('KALLYGRAPHY'), findsAtLeastNWidgets(1));
    expect(find.textContaining('Stories worth'), findsOneWidget);
  });
}
