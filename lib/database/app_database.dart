import 'package:bytebank/models/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (database, version) {
      database.execute('CREATE TABLE contacts('
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'account_number INTEGER)');
    },
    version: 1,
    onDowngrade: onDatabaseDowngradeDelete,
  );
}

Future<int> save(Contact contact) async {
  final Database database = await getDatabase();
  final Map<String, dynamic> contactMap = Map();
  contactMap['name'] = contact.name;
  contactMap['account_number'] = contact.accountNumber;
  return database.insert('contacts', contactMap);
}

Future<List<Contact>> findAll() async {
  final Database database = await getDatabase();
  final List<Map<String, dynamic>> result = await database.query('contacts');

  for (Map<String, dynamic> map in maps) {
    final Contact contact = Contact(
      map['id'],
      map['name'],
      map['account_number'],
    );
    contacts.add(contact);
  }
  return contacts;

  // return createDatabase().then((database) {
  // return database.query('contacts').then(
  // (maps) {
  // final List<Contact> contacts = [];
  // for (Map<String, dynamic> map in maps) {
  // final Contact contact = Contact(
  // map['id'],
  // map['name'],
  // map['account_number'],
  // );
  // contacts.add(contact);
  // }
  // return contacts;
  // },
  // );
  // });
}