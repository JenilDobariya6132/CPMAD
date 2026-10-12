import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/main.dart';

void main() {
  testWidgets('RealtimeChatApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RealtimeChatApp());
    expect(find.byType(RealtimeChatApp), findsOneWidget);
  });
}
