import 'package:flutter_test/flutter_test.dart';

import 'package:kalligraphy/main.dart';

void main() {
  testWidgets('KALLIGRAPHY app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const KalligraphyApp());

    expect(find.text('KALLIGRAPHY'), findsOneWidget);
  });
}
