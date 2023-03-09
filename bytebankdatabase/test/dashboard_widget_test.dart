import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matchers.dart';
import 'mocks.dart';

void main() {
  testWidgets(
    "deve mostrar uma imagem principal, no dashboard",
    (WidgetTester tester) async {
      final MockContactDao_old mockContactDao = MockContactDao_old();
      await tester.pumpWidget(MaterialApp(home: DashboardContainer()));
      final mainImage = find.byType(Image);
      expect(mainImage, findsOneWidget);
    },
  );
  testWidgets(
    "Deve mostrar o item Transferencia enquanto o DashBoard estiver aberto",
    (WidgetTester tester) async {
      final MockContactDao_old mockContactDao = MockContactDao_old();
      await tester.pumpWidget(
        MaterialApp(home: DashboardContainer()),
      );
      final featureTransfer = find.byWidgetPredicate((widget) {
        return buscaMatcherFeature(widget, "Transfer", Icons.monetization_on);
      });
      // final iconTransferenciaItem =
      //     find.widgetWithIcon(FeatureItem, Icons.monetization_on);
      // expect(iconTransferenciaItem, findsOneWidget);
      // final nameTransferenciaItem =
      //     find.widgetWithText(FeatureItem, 'Transfer');
      // expect(nameTransferenciaItem, findsOneWidget);
      expect(featureTransfer, findsOneWidget);
    },
  );

  testWidgets(
    "Deve mostrar a feature Transactions feed enquanto o DashBoard estiver aberto",
    (WidgetTester tester) async {
      final MockContactDao_old mockContactDao = MockContactDao_old();
      await tester.pumpWidget(
        MaterialApp(home: DashboardContainer()),
      );

      final featureTransactionsFeed = find.byWidgetPredicate((widget) {
        return buscaMatcherFeature(widget, "Transactions", Icons.description);
      });
      //  final iconTransactionsItem =
      //      find.widgetWithIcon(FeatureItem, Icons.description);
      //  expect(iconTransactionsItem, findsOneWidget);
      //  final nameTransactionsItem =
      //      find.widgetWithText(FeatureItem, 'Transactions');
      //  expect(nameTransactionsItem, findsOneWidget);
      expect(featureTransactionsFeed, findsOneWidget);
    },
  );
}
