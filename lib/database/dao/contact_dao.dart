import 'package:bytebank/database/app_database.dart';
import 'package:bytebank/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {
  static const String tableSql = 'CREATE TABLE $_tableName('
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';

  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async {
    final Database database = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return database.insert(_tableName, contactMap);
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name;
    contactMap['account_number'] = contact.accountNumber;
    return contactMap;
  }

  Future<List<Contact>> findAll() async {
    final Database database = await getDatabase();
    final List<Map<String, dynamic>> result = await database.query(_tableName);
    List<Contact> contacts = _toList(result);
    return contacts;
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = [];
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }

  Future<int> update(Contact contact) async {
    final Database database = await getDatabase();

    return database.update(
      _tableName,
      _toMap(contact),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> delete(int id) async {
    final database = await getDatabase();

    return database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
