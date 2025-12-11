import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cashapp_free/models/index.dart';

class DatabaseHelper {
  static const String dbName = 'cashapp.db';
  static const String productTable = 'products';
  static const String transactionTable = 'transactions';
  static const String transactionItemTable = 'transaction_items';

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Products table
    await db.execute('''
      CREATE TABLE $productTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        stock INTEGER NOT NULL,
        category TEXT NOT NULL
      )
    ''');

    // Create Transactions table
    await db.execute('''
      CREATE TABLE $transactionTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dateTime TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        itemCount INTEGER NOT NULL
      )
    ''');

    // Create Transaction Items table
    await db.execute('''
      CREATE TABLE $transactionItemTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        transactionId INTEGER NOT NULL,
        productId INTEGER NOT NULL,
        productName TEXT NOT NULL,
        productPrice REAL NOT NULL,
        quantity INTEGER NOT NULL,
        subtotal REAL NOT NULL,
        FOREIGN KEY (transactionId) REFERENCES $transactionTable(id),
        FOREIGN KEY (productId) REFERENCES $productTable(id)
      )
    ''');
  }

  // ============= PRODUCT CRUD =============

  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert(
      productTable,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(productTable);
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      productTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      productTable,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      productTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============= TRANSACTION CRUD =============

  Future<int> insertTransaction(Transaction transaction) async {
    final db = await database;
    final int transactionId = await db.insert(
      transactionTable,
      transaction.toMap(),
    );

    // Insert transaction items
    for (var item in transaction.items) {
      await db.insert(
        transactionItemTable,
        item.copyWith(transactionId: transactionId).toMap(),
      );
    }

    return transactionId;
  }

  Future<List<Transaction>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> transactionMaps = 
        await db.query(transactionTable, orderBy: 'dateTime DESC');

    List<Transaction> transactions = [];
    for (var transactionMap in transactionMaps) {
      final items = await getTransactionItems(transactionMap['id']);
      transactions.add(
        Transaction.fromMap(transactionMap, items: items),
      );
    }

    return transactions;
  }

  Future<Transaction?> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      final items = await getTransactionItems(id);
      return Transaction.fromMap(maps.first, items: items);
    }
    return null;
  }

  Future<List<TransactionItem>> getTransactionItems(int transactionId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      transactionItemTable,
      where: 'transactionId = ?',
      whereArgs: [transactionId],
    );
    return List.generate(maps.length, (i) => TransactionItem.fromMap(maps[i]));
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    // Delete transaction items first
    await db.delete(
      transactionItemTable,
      where: 'transactionId = ?',
      whereArgs: [id],
    );
    // Then delete transaction
    await db.delete(
      transactionTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============= STATISTICS =============

  Future<Map<String, dynamic>> getDailyStatistics(DateTime date) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(*) as transactionCount, SUM(totalAmount) as totalAmount
      FROM $transactionTable
      WHERE dateTime >= ? AND dateTime < ?
    ''', [startOfDay.toIso8601String(), endOfDay.toIso8601String()]);

    if (result.isNotEmpty && result[0]['totalAmount'] != null) {
      return {
        'transactionCount': result[0]['transactionCount'] ?? 0,
        'totalAmount': (result[0]['totalAmount'] as num).toDouble(),
      };
    }
    return {'transactionCount': 0, 'totalAmount': 0.0};
  }

  Future<double> getTotalRevenue() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(totalAmount) as total FROM $transactionTable
    ''');

    if (result.isNotEmpty && result[0]['total'] != null) {
      return (result[0]['total'] as num).toDouble();
    }
    return 0.0;
  }

  Future<int> getTotalTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT COUNT(*) as count FROM $transactionTable
    ''');

    return result[0]['count'] as int? ?? 0;
  }

  // ============= HELPER METHODS =============

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

extension TransactionItemExtension on TransactionItem {
  TransactionItem copyWith({
    int? id,
    int? transactionId,
    int? productId,
    String? productName,
    double? productPrice,
    int? quantity,
    double? subtotal,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}
