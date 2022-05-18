import 'package:flutter/material.dart';

import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/screens/contact_form.dart';
import 'package:bytebankdatabase/screens/transaction_form.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';

class ContactsList extends StatefulWidget {
  bool optionsVisible;
  ContactsList({
    this.optionsVisible = true,
  });
  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  final ContactDao _contactDao = ContactDao();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: FutureBuilder<List<Contact>>(
        future: _contactDao.findAll(),
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

                    return _ContactItem(
                      visibleOptions: widget.optionsVisible,
                      contact: _contactItem,
                      onClick: () {
                        _novaTransferencia(context, _contactItem);
                      },
                      deleteContact: () {
                        _deleteContact(_contactItem);
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

  void _newContact(BuildContext context) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(builder: (context) => ContactForm()),
        )
        .then((value) => setState(() {}));
  }

  void _novaTransferencia(BuildContext context, Contact _contactItem) {
    final isDialog = widget.optionsVisible;
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => TransactionForm(_contactItem),
          ),
        )
        .then((value) => !isDialog ? Navigator.pop(context) : print('false'));
  }

  void _deleteContact(Contact _contactItem) {
    _contactDao.delete(_contactItem.id!).whenComplete(() => setState(() {}));
  }

  void _updateContact(BuildContext context, Contact _contactItem) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => ContactForm(contactInicial: _contactItem),
          ),
        )
        .whenComplete(() => setState(() {}));
  }
}

class _ContactItem extends StatefulWidget {
  final Contact contact;
  final Function onClick;
  final Function deleteContact;
  final Function updateContact;
  final bool visibleOptions;

  const _ContactItem(
      {Key? key,
      required this.contact,
      required this.onClick,
      required this.deleteContact,
      required this.updateContact,
      required this.visibleOptions})
      : super(key: key);

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
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
