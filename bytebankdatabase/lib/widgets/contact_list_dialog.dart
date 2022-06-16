import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/screens/contact/contacts_list.dart';
import 'package:flutter/material.dart';

class ContactsDialog extends StatefulWidget {
  @override
  State<ContactsDialog> createState() => _ContactsDialogState();
}

class _ContactsDialogState extends State<ContactsDialog> {
  final ContactDao _contactDao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: ContactsListContainer(
        optionsVisible: false,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
