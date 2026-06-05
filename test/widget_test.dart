import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:numeromagico/app/app.dart';

void main() {
  testWidgets('Magic Number Game Smoke Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that the game screen title is shown
    expect(find.text('El Número Mágico'), findsOneWidget);

    // Verify that the attempts count starts at 3
    expect(find.text('Intentos restantes: 3'), findsOneWidget);

    // Verify that the input field is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the "Adivinar" button is present
    expect(find.text('Adivinar'), findsOneWidget);
  });
}
