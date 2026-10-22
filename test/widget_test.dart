import 'package:flutter_test/flutter_test.dart';
import 'package:nusa_travel/main.dart';

void main() {
  testWidgets('Splash menampilkan tombol Mulai Eksplorasi', (tester) async {
    await tester.pumpWidget(const NusaTravelApp());
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Mulai Eksplorasi'), findsOneWidget);
  });
}