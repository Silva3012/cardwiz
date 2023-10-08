import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user_credit_card.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // A method to access the SQLite database
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the SQLite database and create a credit_cards table
  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), "credit_card.db");
    return await openDatabase(
        path,
        version: 1,
      onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE credit_cards (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              type TEXT,
              number TEXT,
              name TEXT,
              month INTEGER,
              year INTEGER,
              cvv INTEGER,
              selectedCountry TEXT
            )
          ''');
      },
    );
  }

  // CRUD OPERATIONS
  // Insert a credit card record into the database
  Future<void> insertCreditCard(UserCreditCard creditCard) async {
    final Database db = await database;
    await db.insert("credit_cards", creditCard.toMap());
    print('Credit card inserted: $creditCard');
  }

  // Read all credit card records from the database
  Future<List<UserCreditCard>> getCreditCards() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("credit_cards");
    final List<UserCreditCard> creditCards = List.generate(maps.length, (index) {
      return UserCreditCard.fromMap(maps[index]);
    });
    print('Retrieved credit cards: $creditCards');
    return creditCards;
  }

  // Checking the DB if the card already exist
  Future<bool> checkDuplicateCard(UserCreditCard card) async {
    final db = await database;
    final result = await db.query(
      "credit_cards",
      where: "number = ? AND name = ? AND month = ? AND year = ? AND cvv = ? AND selectedCountry = ?",
      whereArgs: [
        card.number,
        card.name,
        card.month,
        card.year,
        card.cvv,
        card.selectedCountry,
      ],
    );
    return result.isNotEmpty;
  }
}

/*
Persisting data with SQLite
https://docs.flutter.dev/cookbook/persistence/sqlite
https://www.youtube.com/watch?v=q8UXj-44dk8
https://github.com/yehya-qassim/local_database/blob/master/lib/services/database_helper.dart
 */