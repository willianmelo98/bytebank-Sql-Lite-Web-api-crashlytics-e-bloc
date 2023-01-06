import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("deve mostrar uma imagem principal, no dashboard",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets(
      "Deve mostrar a primeira Feature enquanto o DashBoard estiver aberto",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
    final firstFeatureItem = find.byType(FeatureItem);
    expect(firstFeatureItem, findsWidgets);
  });
}
