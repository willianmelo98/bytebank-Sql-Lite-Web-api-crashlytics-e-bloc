import 'package:bytebankdatabase/database/dao/contact_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String dbPath = await getDatabasesPath();
  final String path = join(dbPath, 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.sqlTable);
    },
    version: 1,
  );
  //return getDatabasesPath().then((dbPath) {
  //  final String path = join(dbPath, 'bytebank.db');
  //  return openDatabase(
  //    path,
  //    onCreate: (db, version) {
  //      db.execute('CREATE TABLE contacts('
  //          'id INTEGER PRIMARY KEY, '
  //          'name TEXT, '
  //          'accountNumber INTEGER)');
  //    },
  //    version: 1, /*onDowngrade: onDatabaseDowngradeDelete*/
  //  );
  //});
}
