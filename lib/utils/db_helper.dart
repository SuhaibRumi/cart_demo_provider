import 'package:catalog_app_provider/model/cart_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  final dbName = 'cart';

  Future<Database?> get db async {
    if (_db != null) {
      return _db!;
    }

    return _db = await initDatabase();
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, dbName);
    var db = await openDatabase(path, version: 2, onCreate: _onCreateDB);
    return db;
  }

  Future<void> _onCreateDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart (id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE,productName TEXT,productPrice INTEGER,initialPrice INTEGER ,quantity INTEGER,unitTag TEXT ,imageUrl TEXT )');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClinet = await db;
    await dbClinet!.insert('cart', cart.toMap());
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClinet = await db;
    final List<Map<String, Object?>> queryResult =
        await dbClinet!.query('cart');
    return queryResult.map((e) => Cart.fromMap(e)).toList();
  }

  Future<int> delete(int id) async {
    var dbClinet = await db;
    return await dbClinet!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Cart cart) async {
    var dbClinet = await db;
    return await dbClinet!
        .update('cart', cart.toMap(), where: 'id = ?', whereArgs: [cart.id]);
  }
}
