// import 'dart:async';
// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'favorite_model.dart';

// class DBProvider {
//   DBProvider._();
//   static final DBProvider db = DBProvider._();
//   static Database _database;

//   Future<Database> get database async {
//     if (_database != null) return _database;

//     // if _database is null we instantiate it
//     _database = await initDB();
//     return _database;
//   }

//   initDB() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, "FavoriteArticle.db");
//     return await openDatabase(path, version: 1, onOpen: (db) {},
//         onCreate: (Database db, int version) async {
//       await db.execute("CREATE TABLE Client ("
//           "id String PRIMARY KEY,"
//           "title TEXT,"
//           "description TEXT,"
//           "images TEXT,"
//           "date TEXT,"
//           "favors TEXT,"
//           "opens TEXT,"
//           "shares TEXT"
//           ")");
//     });
//   }
// }

// newClient(FavoriteModel newFavorite) async {
//   final db = await database;
//   var res = await db.insert("Client", newClient.toMap());
//   return res;
// }
