import 'package:flutter_test/flutter_test.dart';
import 'package:safqa_mobile/src/app/safqa_app.dart';

void main() {
  testWidgets('Safqa app renders the Arabic broker portal', (tester) async {
    await tester.pumpWidget(const SafqaApp());

    expect(find.text('\u0635\u0641\u0642\u0629'), findsOneWidget);
    expect(
      find.text(
        '\u0627\u0642\u0641\u0644 \u0639\u0642\u062f\u0643 \u0645\u0646 \u0645\u0643\u0627\u0646 \u0648\u0627\u062d\u062f',
      ),
      findsOneWidget,
    );
  });
}
