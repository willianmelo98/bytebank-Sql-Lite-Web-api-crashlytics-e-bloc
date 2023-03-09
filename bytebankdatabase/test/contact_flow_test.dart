import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/main.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/screens/contact_form.dart';
import 'package:bytebankdatabase/screens/contacts_list.dart';
import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contact_flow_test.mocks.dart';
import 'matchers.dart';
import 'mocks.dart';

@GenerateMocks([ContactDao])
void main() {
  testWidgets(
    "Deve salvar um contato",
    (WidgetTester tester) async {
      final MockContactDao mockContactDao = MockContactDao();
      final MockTransferenciaWebCliente mockTransferenciaWebCliente =
          MockTransferenciaWebCliente();

      when(mockContactDao.findAll()).thenAnswer((_) async => []);

      await tester.pumpWidget(Bytebank(
        contactDao: mockContactDao,
        transferenciaWebCliente: mockTransferenciaWebCliente,
      ));

      final dashboardItem = find.byType(DashboardContainer);

      expect(dashboardItem, findsOneWidget);

      final transferFeature = find.byWidgetPredicate((widget) =>
          buscaMatcherFeature(widget, "Transfer", Icons.monetization_on));
      expect(transferFeature, findsOneWidget);

      await tester.tap(transferFeature);
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      final contactList = find.byType(ContactsList);
      expect(contactList, findsOneWidget);

      final fabContactList =
          find.widgetWithIcon(FloatingActionButton, Icons.add);
      expect(fabContactList, findsOneWidget);

      await tester.tap(fabContactList);
      for (int i = 0; i < 5; i++) {
        await tester.pump(Duration(seconds: 1));
      }

      final contactForm = find.byType(ContactForm);
      expect(contactForm, findsOneWidget);

      final textNameField = find.byWidgetPredicate((Widget widget) {
        return textFieldByLabelTextMatcher(widget, 'Full Name');
      });
      expect(textNameField, findsOneWidget);
      await tester.enterText(textNameField, "Will");

      final textAccountNumberField = find.byWidgetPredicate((Widget widget) {
        return textFieldByLabelTextMatcher(widget, 'Account number');
      });
      expect(textAccountNumberField, findsOneWidget);
      await tester.enterText(textAccountNumberField, '1000');

      final saveButton = find.widgetWithText(ElevatedButton, 'Criar');
      expect(saveButton, findsOneWidget);
      verify(mockContactDao.findAll());
    },
  );
}
