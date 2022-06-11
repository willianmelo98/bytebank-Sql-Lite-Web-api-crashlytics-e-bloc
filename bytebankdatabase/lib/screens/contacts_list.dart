import 'package:flutter/material.dart';

import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/screens/contact_form.dart';
import 'package:bytebankdatabase/screens/transaction_form.dart';
import 'package:bytebankdatabase/widgets/container.dart';
import 'package:bytebankdatabase/widgets/progress_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/giff_dialog.dart';

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contact> _contacts;

  const LoadedContactsListState(this._contacts);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async {
    emit(LoadingContactsListState());
    dao.findAll().then((contacts) => emit(LoadedContactsListState(contacts)));
  }
}

class ContactsListContainer extends BlocContainer {
  bool optionsVisible;
  ContactsListContainer({
    this.optionsVisible = true,
  });
  @override
  Widget build(BuildContext context) {
    final ContactDao dao = ContactDao();

    return BlocProvider<ContactsListCubit>(
      create: (BuildContext context) {
        final cubit = ContactsListCubit();
        cubit.reload(dao);
        return cubit;
      },
      child: ContactsList(optionsVisible: optionsVisible, dao: dao),
    );
  }
}

class ContactsList extends StatelessWidget {
  bool optionsVisible;
  final ContactDao dao;
  ContactsList({required this.optionsVisible, required this.dao});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is InitContactsListState ||
              state is LoadingContactsListState) {
            return ProgressoCustomizado();
          }
          if (state is LoadedContactsListState) {
            final List<Contact> contactList = state._contacts;
            return ListView.builder(
              itemBuilder: (context, index) {
                final Contact _contactItem = contactList[index];

                return _ContactItem(
                  visibleOptions: optionsVisible,
                  contact: _contactItem,
                  onClick: () {
                    _novaTransferencia(context, _contactItem);
                  },
                  deleteContact: () {
                    _deleteContact(context, _contactItem);
                  },
                  updateContact: () {
                    _updateContact(context, _contactItem);
                  },
                );
              },
              itemCount: contactList.length,
            );
          }

          return GifDialog(
            message: 'Error',
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: optionsVisible,
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

    context.read<ContactsListCubit>().reload(dao);
  }

  void _novaTransferencia(BuildContext context, Contact _contactItem) async {
    final isDialog = !optionsVisible;

    await push(context, TransactionFormContainer(_contactItem));

    if (isDialog) {
      Navigator.pop(context);
    }
  }

  void _deleteContact(BuildContext context, Contact _contactItem) async {
    await dao.delete(_contactItem.id!);
    context.read<ContactsListCubit>().reload(dao);
  }

  void _updateContact(BuildContext context, Contact _contactItem) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactForm(contactInicial: _contactItem),
      ),
    );
    context.read<ContactsListCubit>().reload(dao);
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
