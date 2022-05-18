import 'package:bytebankdatabase/database/app_database.dart';
import 'package:bytebankdatabase/model/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String sqlTable = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';
  static const String _tableName = "contacts";
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async {
    final Database database = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return database.insert(_tableName, contactMap);

    //return getDatabase().then((database) {
    //  final Map<String, dynamic> contactMap = Map();
    //  contactMap['name'] = contact.name;
    //  contactMap['accountNumber'] = contact.accountNumber;
    //  return database.insert('contacts', contactMap);
    //});
  }

  Future<int> update(Contact contact) async {
    final Database db = await getDatabase();
    final Map<String, dynamic> contactMap = _toMap(contact);
    return db.update(
      _tableName,
      contactMap,
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final Database db = await getDatabase();
    return db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name;
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> contatosMap =
        await database.query(_tableName);
    List<Contact> listaContatos = _toList(contatosMap);
    return listaContatos;

    //
    //return getDatabase().then((database) {
    //  return database.query('contacts').then((contatosMap) {
    //    final List<Contact> listaContatos = [];
    //    for (Map<String, dynamic> mapContat in contatosMap) {
    //      final Contact contato = Contact(
    //          id: mapContat['id'],
    //          name: mapContat['name'],
    //          accountNumber: mapContat['accountNumber']);
    //      listaContatos.add(contato);
    //    }
    //    return listaContatos;
    //  });
    //});
  }

  List<Contact> _toList(List<Map<String, dynamic>> contatosMap) {
    final List<Contact> listaContatos = [];
    for (Map<String, dynamic> mapContat in contatosMap) {
      final Contact contato = Contact(
          id: mapContat[_id],
          name: mapContat[_name],
          accountNumber: mapContat[_accountNumber]);
      listaContatos.add(contato);
    }
    return listaContatos;
  }
}
