import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/main.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/model/transferencia.dart';
import 'package:bytebankdatabase/screens/contacts_list.dart';
import 'package:bytebankdatabase/screens/dashboard.dart';
import 'package:bytebankdatabase/screens/transaction_form.dart';
import 'package:bytebankdatabase/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'matchers.dart';
import 'mocks.dart';
import 'transfer_flow_test.mocks.dart';

@GenerateMocks([ContactDao])
void main() {
  testWidgets(
    "Deve realizar uma transfer",
    ((tester) async {
      final contact = Contact(id: 0, name: 'Will', accountNumber: 1000);
      final MockContactDao mockContactDao = MockContactDao();
      final MockTransferenciaWebCliente mockTransferenciaWebCliente =
          MockTransferenciaWebCliente();

      await tester.pumpWidget(Bytebank(
        contactDao: mockContactDao,
        transferenciaWebCliente: mockTransferenciaWebCliente,
      ));

      final dashboardItem = find.byType(DashboardContainer);

      when(mockContactDao.findAll()).thenAnswer((invocation) async {
        return [contact];
      });

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

      verify(mockContactDao.findAll()).called(1);

      final contactItem = find.byWidgetPredicate((widget) {
        if (widget is ContactItem) {
          return widget.contact.name == 'Will' &&
              widget.contact.accountNumber == 1000;
        }
        return false;
      });

      expect(contactItem, findsOneWidget);
      await tester.tap(contactItem);
      await tester.pumpAndSettle();

      final transferenciaForm = find.byType(TransactionForm);
      expect(transferenciaForm, findsOneWidget);

      final contatoName = find.text('Will');
      expect(contatoName, findsOneWidget);

      final numeroConta = find.text('1000');
      expect(numeroConta, findsOneWidget);

      final textFildValue = find.byWidgetPredicate((widget) {
        return textFieldByLabelTextMatcher(widget, 'Value');
      });
      expect(textFildValue, findsOneWidget);

      await tester.enterText(textFildValue, '200');

      final transferButton = find.widgetWithText(ElevatedButton, 'Transfer');
      expect(transferButton, findsOneWidget);

      await tester.tap(transferButton);
      await tester.pumpAndSettle();

      final transactionAuthDialog = find.byType(AlertAuthDialog);
      expect(transactionAuthDialog, findsOneWidget);

      final textFieldPassword =
          find.byKey(transactionAuthDialogTextFieldPasswordKey);
      expect(textFieldPassword, findsOneWidget);

      final cancelButton = find.widgetWithText(ElevatedButton, 'Cancel');
      expect(cancelButton, findsOneWidget);

      final confirmButton = find.widgetWithText(ElevatedButton, 'confirm');
      expect(confirmButton, findsOneWidget);

      /*  when(mockTransferenciaWebCliente.save(
              Transferencia(null, 200, contact), '1000'))
          .thenAnswer((_) async => Transferencia(null, 200, contact));

      await tester.tap(confirmButton); */
    }),
  );
}
