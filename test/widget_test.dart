import 'package:betcode_app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BetCodeApp renders without crashing', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: BetCodeApp()));

    // The app should render and show the title somewhere in the widget tree.
    expect(find.text('BetCode'), findsOneWidget);
  });
}
