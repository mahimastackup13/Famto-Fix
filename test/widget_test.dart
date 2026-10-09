import 'package:flutter_test/flutter_test.dart';

import 'package:famto_mini_booking/app.dart';

void main() {
  testWidgets('Login as guest opens Home and loads categories', (tester) async {
    await tester.pumpWidget(const FamtoApp());
    expect(find.text('Login as Guest'), findsOneWidget);

    await tester.tap(find.text('Login as Guest'));
    await tester.pump(const Duration(milliseconds: 500)); // page transition
    await tester.pump(const Duration(seconds: 1)); // simulated latency

    expect(find.text('Electrician'), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
  });
}
