import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/dog.dart';

class Operations {
  //create singleton
  Operations._();

  static final Operations db = Operations._();

  //database
  late final Database database;

  // create database
  Future<void> createDb() async {
    database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'doggie_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // insert dog into database
  Future<void> insertDog(Dog dog) async {
    int status = await database.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('status: $status');
  }

  // A method that retrieves all the dogs from the dogs table.
  Future<List<Dog>> retriveDogs() async {
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await database.query('dogs');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  // A method that updates the given dog.
  Future<void> updateDog(Dog dog) async {
    // Update the given Dog.
    int status = await database.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
    print('status: $status');
  }

  // A method that deletes the given dog.
  Future<void> deleteDog(int id) async {
    // Remove the Dog from the database.

    int status = await database.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );

    print('status: $status');
  }
}
