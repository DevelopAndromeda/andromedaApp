import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class serviceDB {
  static const dbName = 'andromeda.db';
  static const dbVersion = 3;

  static final serviceDB instance = serviceDB();
  static Database? _database;

  //Create Tables
  Future _onCreate(Database db, int version) async {
    debugPrint('Database Version onCreate: $version');
    await db.execute("DROP TABLE IF EXISTS users;");
    await db.execute("DROP TABLE IF EXISTS stores;");
    await db.execute("DROP TABLE IF EXISTS states;");
    await db.execute("DROP TABLE IF EXISTS favorites;");
    await db.execute(
        'CREATE TABLE IF NOT EXISTS users(id_user INTEGER PRIMARY KEY, nombre TEXT NULL, apellido_paterno TEXT NULL, apellido_materno TEXT NULL, telefono TEXT NULL, codigo_postal TEXT NULL, estado TEXT NULL, password TEXT, username TEXT NULL, lat TEXT NULL, long TEXT NULL, token TEXT NULL, id INTEGER NULL, group_id INTEGER NULL, zip_code TEXT NULL, name_city TEXT NULL, name_business TEXT NULL, rfc_id TEXT NULL, genero TEXT NULL, img_profile TEXT NULL)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS stores(id_store INTEGER PRIMARY KEY, nombre TEXT, direccion TEXT, id_tipo_comida INTEGER, id_tipo_restaurante INTEGER, cantidad_mesas NUMERIC)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS states(id INTEGER PRIMARY KEY, label TEXT, code TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY)');
  }

  //Create Database
  initBD() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path,
        version: dbVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
    //return await openDatabase(path, version: dbVersion, onCreate: _onCreate);
  }

  // UPGRADE DATABASE TABLES
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('Database Version onUpgrade: OLD: $oldVersion NEW: $newVersion');
    if (oldVersion < newVersion) {
      // you can execute drop table and create table
      await db.execute("DROP TABLE IF EXISTS users;");
      await db.execute("DROP TABLE IF EXISTS favorites;");
      await db.execute(
          'CREATE TABLE IF NOT EXISTS users(id_user INTEGER PRIMARY KEY, nombre TEXT NULL, apellido_paterno TEXT NULL, apellido_materno TEXT NULL, telefono TEXT NULL, codigo_postal TEXT NULL, estado TEXT NULL, password TEXT, username TEXT NULL, lat TEXT NULL, long TEXT NULL, token TEXT NULL, id INTEGER NULL, group_id INTEGER NULL, zip_code TEXT NULL, name_city TEXT NULL, name_business TEXT NULL, rfc_id TEXT NULL, genero TEXT NULL, img_profile TEXT NULL)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY)');
    }
  }

  //Delete Database
  Future<void> deleteDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    databaseFactory.deleteDatabase(path);
  }

  //Delete All tables
  Future<void> cleanAllTable() async {
    Database? db = await instance.database;
    Batch batch = db!.batch();

    if (dbVersion == 3) {
      batch.execute('DELETE FROM users;');
      batch.execute('DELETE FROM favorites;');
    } else {
      batch.execute('DELETE FROM users;');
      batch.execute('DELETE FROM stores;');
      batch.execute('DELETE FROM states;');
      batch.execute('DELETE FROM favorites;');
    }

    await batch.commit();
  }

  //Get Instance databes
  Future<Database?> get database async {
    _database ??= await initBD();
    return _database;
  }

  //CRUD
  //Insert - Create
  Future<int> insertRecord(String table, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.insert(table, row);
  }

  //Select - Read
  Future<List<Map<String, dynamic>>> queryRecord(String table) async {
    Database? db = await instance.database;
    return await db!.query(table);
  }

  //Update - Update
  Future<int> updateRecord(String table, Map<String, dynamic> update,
      String columnId, int id) async {
    Database? db = await instance.database;
    return await db!
        .update(table, update, where: '$columnId = ?', whereArgs: [id]);
  }

  //Delete - Delete
  Future<int> deleteRecord(String table, String columnId, int id) async {
    Database? db = await instance.database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  //Like
  Future<List<Map<String, dynamic>>> searchResults(
      String table, String columnId, String search) async {
    Database? db = await instance.database;
    return await db!
        .query(table, where: '$columnId LIKE ?', whereArgs: ['%$search%']);
    //var response = await db.query(TABLE_WORDS, where: '$COL_ENGLISH_WORD = ? OR $COL_GERMAN_WORD = ?', whereArgs: [userSearch, userSearch]);
  }

  //ById
  Future<List<Map<String, dynamic>>> getById(
      String table, String columnId, int id) async {
    Database? db = await instance.database;
    return await db!.query(table, where: '$columnId = ?', whereArgs: [id]);
    //var response = await db.query(TABLE_WORDS, where: '$COL_ENGLISH_WORD = ? OR $COL_GERMAN_WORD = ?', whereArgs: [userSearch, userSearch]);
  }
}