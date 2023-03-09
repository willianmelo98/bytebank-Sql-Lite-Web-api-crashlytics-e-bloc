import 'package:flutter/material.dart';

import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/screens/contact_form.dart';
import 'package:bytebankdatabase/screens/transaction_form.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';

import '../widgets/app_dependencias.dart';

class ContactsList extends StatefulWidget {
  bool optionsVisible;
  ContactsList({
    Key? key,
    this.optionsVisible = true,
  }) : super(key: key);
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    final dependencias = AppDependencias.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: FutureBuilder<List<Contact>>(
        future: dependencias.contactDao.findAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            snapshot.error;
          }
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              // TODO: Handle this case.
              break;
            case ConnectionState.waiting:
              return ProgressoCustomizado(
                mensagemDoIndicator: 'Em andamento',
              );

            case ConnectionState.active:
              // TODO: Handle this case.
              break;
            case ConnectionState.done:
              if (snapshot.data != null) {
                final List<Contact> contactList = snapshot.data ?? [];
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final Contact _contactItem = contactList[index];

                    return ContactItem(
                      visibleOptions: widget.optionsVisible,
                      contact: _contactItem,
                      onClick: () {
                        _novaTransferencia(context, _contactItem);
                      },
                      deleteContact: () {
                        _deleteContact(_contactItem, dependencias.contactDao);
                      },
                      updateContact: () {
                        _updateContact(context, _contactItem);
                      },
                    );
                  },
                  itemCount: contactList.length,
                );
              }
              break;
          }
          return Text("unknown error");
        },
      ),
      floatingActionButton: Visibility(
        visible: widget.optionsVisible,
        child: FloatingActionButton(
          onPressed: () {
            _newContact(context);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void _newContact(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ContactForm()),
    );
    setState(() {});
  }

  void _novaTransferencia(BuildContext context, Contact _contactItem) async {
    final isDialog = !widget.optionsVisible;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TransactionForm(_contactItem),
      ),
    );
    if (isDialog) {
      Navigator.pop(context);
    }
  }

  void _deleteContact(Contact _contactItem, ContactDao contactDao) async {
    await contactDao.delete(_contactItem.id!);
    setState(() {});
  }

  void _updateContact(BuildContext context, Contact _contactItem) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactForm(
          contactInicial: _contactItem,
        ),
      ),
    );
    setState(() {});
  }
}

class ContactItem extends StatefulWidget {
  final Contact contact;
  final Function onClick;
  final Function deleteContact;
  final Function updateContact;
  final bool visibleOptions;

  const ContactItem(
      {Key? key,
      required this.contact,
      required this.onClick,
      required this.deleteContact,
      required this.updateContact,
      required this.visibleOptions})
      : super(key: key);

  @override
  State<ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<ContactItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          widget.onClick();
        },
        title: Text(
          widget.contact.name,
          style: TextStyle(fontSize: 24.0),
        ),
        subtitle: Text(
          widget.contact.accountNumber.toString(),
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: Visibility(
          visible: widget.visibleOptions,
          child: PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('delete'),
                  onTap: () {
                    widget.deleteContact();
                  },
                ),
                PopupMenuItem(
                  value: 'update',
                  child: Text('update'),
                )
              ];
            },
            onSelected: (value) {
              if (value == 'update') {
                widget.updateContact();
              }
            },
          ),
        ),
      ),
    );
  }
}
