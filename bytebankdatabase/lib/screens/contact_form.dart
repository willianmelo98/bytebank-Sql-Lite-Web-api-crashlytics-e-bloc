import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:bytebankdatabase/widgets/app_dependencias.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final Contact? contactInicial;

  ContactForm({
    this.contactInicial,
  });

  @override
  State<ContactForm> createState() =>
      _ContactFormState(contactUpdate: contactInicial);
}

class _ContactFormState extends State<ContactForm> {
  final Contact? contactUpdate;
  _ContactFormState({this.contactUpdate = null});
  final TextEditingController controllerName = new TextEditingController();
  final TextEditingController controllerContact = new TextEditingController();
  String textoButton = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      controllerName.text = contactUpdate?.name ?? '';
      controllerContact.text = contactUpdate?.accountNumber.toString() ?? '';
      textoButton = contactUpdate != null ? 'Atualizar' : 'Criar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final dependencias = AppDependencias.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Contact"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                labelText: "Full Name",
              ),
              style: TextStyle(fontSize: 24.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TextField(
                controller: controllerContact,
                decoration: InputDecoration(
                  labelText: "Account number",
                ),
                style: TextStyle(fontSize: 24.0),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {
                    _saveOnDatabase(context, dependencias.contactDao);
                  },
                  child: Text(textoButton),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _saveOnDatabase(BuildContext context, ContactDao contactDao) async {
    final String nameContact = controllerName.text;
    final int numeroContact = int.tryParse(controllerContact.text) ?? 000;
    Contact contactCreated = Contact(
      id: contactUpdate?.id,
      name: nameContact,
      accountNumber: numeroContact,
    );
    if (nameContact != "" && numeroContact != 0) {
      if (contactUpdate?.id == null) {
        await contactDao.save(contactCreated);
        Navigator.pop(context);
      } else {
        await contactDao.update(contactCreated);
        Navigator.pop(context, contactCreated);
      }
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Alerta'),
          content: const Text('Preencha todos os campos'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
