import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<sql.Database> db() async {
    return sql.openDatabase("studentsData.db", version: 1,
        onCreate: (sql.Database database, int version) async {
      await createTables(database);
    });
  }

  static Future<void> createTables(sql.Database database) async {
    database.execute("""CREATE TABLE employees(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    name TEXT,
    code INTEGER,
    pin INTEGER,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
    database.execute("""CREATE TABLE attendance(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    code INTEGER,
    image TEXT,
    status TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<int> createEmployee(String name, int code, int pin) async {
    final db = await SQLHelper.db();
    final data = {
      "name": name,
      "code": code,
      "pin": pin,
    };
    final id = db.insert("employees", data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getEmployees() async {
    final db = await SQLHelper.db();
    return db.query("employees", orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getEmployee(int id) async {
    final db = await SQLHelper.db();
    return db.query("employees", where: "id=?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getAttendance(int code) async {
    final db = await SQLHelper.db();
    final result=db.query("attendance", where: "code=?", whereArgs: [code]);
    return result;
  }

  static Future<List<Map<String, dynamic>>> checkLogin(
      int code, int pin) async {
    final db = await SQLHelper.db();
    final result = db
        .query("employees", where: "code=? AND pin=?", whereArgs: [code, pin]);
    return result;
  }

  static Future<int> createEntry(int code, String image, String status) async {
    final db = await SQLHelper.db();
    final data = {
      "code": code,
      "image": image,
      "status": status,
    };
    final id = db.insert("attendance", data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<String?> checkStatus(int code) async {
    final db = await SQLHelper.db();
    final result = await db.rawQuery(
        "SELECT status, createdAt FROM attendance WHERE code=? ORDER BY createdAt DESC LIMIT 1",
        [code]);
    if (result.isEmpty) {
      return null;
    } else {
      Map<String, dynamic> first = result.first;
      String? status = first["status"];
      return status;
    }
  }

  static Future<String> getName(int code) async {
    final db = await SQLHelper.db();
    final result = await db
        .rawQuery("SELECT name FROM employees WHERE code=? LIMIT 1", [code]);
    Map<String, dynamic> first = result.first;
    String name = first["name"];
    return name;
  }

  static Future<List<Map<String, dynamic>>> getEntries(int code) async {
    final db = await SQLHelper.db();
    return db.query("attendance", where: "code=?", whereArgs: [code]);
  }
}
