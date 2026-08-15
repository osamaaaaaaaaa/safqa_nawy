import 'package:flutter_test/flutter_test.dart';
import 'package:safqa_mobile/src/app/safqa_app.dart';

void main() {
  testWidgets('Safqa app renders the Arabic broker portal', (tester) async {
    await tester.pumpWidget(const SafqaApp());

    expect(
      find.text(
        '\u0648\u0633\u064a\u0637 \u0635\u0641\u0642\u0629 \u0627\u0644\u0645\u0639\u062a\u0645\u062f',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        '\u0643\u0644 \u0639\u0642\u062f\u060c \u0639\u0645\u0648\u0644\u0629\u060c \u0648\u0645\u0633\u062a\u0646\u062f \u0641\u064a \u0645\u0633\u0627\u0631 \u0648\u0627\u062d\u062f \u0648\u0627\u0636\u062d.',
      ),
      findsOneWidget,
    );
  });
}
