import 'package:appentus/code/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UsersDatabase {
  static final UsersDatabase instance = UsersDatabase._init();
  static Database? _database;
  UsersDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'myDB.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY";
    final textType = "TEXT";
    final intType = "INTEGER";

      await db.execute('''
      CREATE TABLE $userTable (
        ${UserFields.id} $idType,
        ${UserFields.name} $textType,
        ${UserFields.email} $textType,
        ${UserFields.password} $textType,
        ${UserFields.number} $intType,
        ${UserFields.image} $textType
      )
    ''');
  }

  Future createUser(User user) async {
    final db = await instance.database;
    await db.insert(userTable, user.toJson());
  }

  Future<List<User>> readAll() async {
    final db = await instance.database;
    final result = await db.query(userTable);
    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<User> getUser(int id) async {
    final db = await instance.database;
    final map = await db.query(
      userTable,
      columns: UserFields.values,
      where: '${UserFields.id} = ?',
      whereArgs: [id]
    );
    if (map.isNotEmpty) {
      return User.fromJson(map.first);
    }
    throw Exception('User does not exist');
  }

  Future<User> checkUser(String email, String password) async {
    final db = await instance.database;
    final map = await db.query(
      userTable,
      columns: UserFields.values,
      where: '${UserFields.email} = ?',
      whereArgs: [email]
    );
    if (map.isNotEmpty) {
      User found = User.fromJson(map.first);
      if (found.password == password) return found;
      return dummy;
    }
    throw Exception('User does not exist');
  }
}