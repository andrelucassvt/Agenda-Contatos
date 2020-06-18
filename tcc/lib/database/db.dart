import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String idadeColumn = "idadeColumn";
final String sexoColumn = "sexoColumn";
final String corColumn = "corColumn";
final String exameColumn = "exameColumn";
final String dataColumn = "dataColumn";


class ContactHelper {

  static final ContactHelper _instance = ContactHelper.internal();

  factory ContactHelper() => _instance;

  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $idadeColumn TEXT,$sexoColumn TEXT, $corColumn TEXT,$exameColumn TEXT,$dataColumn TEXT)"
      );
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idColumn, nameColumn, idadeColumn, sexoColumn, corColumn,exameColumn,dataColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
    if(maps.length > 0){
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(contactTable, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(contactTable,
        contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    List<Contact> listContact = List();
    for(Map m in listMap){
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async {
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    Database dbContact = await db;
    dbContact.close();
  }

}

class Contact {

  int id;
  String name;
  String idade;
  String sexo;
  String cor;
  String exame;
  String data;

  Contact();

  Contact.fromMap(Map map){
    id = map[idColumn];
    name = map[nameColumn];
    idade = map[idadeColumn];
    sexo = map[sexoColumn];
    cor = map[corColumn];
    exame = map[exameColumn];
    data = map[dataColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nameColumn: name,
      idadeColumn: idade,
      sexoColumn: sexo,
      corColumn: cor,
      exameColumn: exame,
      dataColumn: data
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }
}