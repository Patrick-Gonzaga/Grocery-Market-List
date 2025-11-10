import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String groceryTable = "groceryTable";
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String valueColumn = "valueColumn";
final String oldValueColumn = "oldValueColumn";
final String imgColumn = "imgColumn";
final String typeColumn = "typeColumn";
final String isSelectedColumn = "isSelectedColumn";

class GroceryHelper {
  static final GroceryHelper _instance = GroceryHelper.internal();

  factory GroceryHelper() => _instance;

  GroceryHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDataBase();
      return _db!;
    }
  }

  Future<Database> initDataBase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'grocery.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
          "CREATE TABLE $groceryTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT,"
          " $valueColumn TEXT, $oldValueColumn TEXT, $imgColumn TEXT, $typeColumn TEXT, $isSelectedColumn INTEGER)",
        );
      },
    );
  }

  Future<GroceryItem> saveGroceryItem(GroceryItem groceryItem) async {
    Database database = await db;
    groceryItem.id = await database.insert(groceryTable, groceryItem.toMap());
    return groceryItem;
  }

  Future<GroceryItem?> getGroceryItem(int id) async {
    Database database = await db;
    List<Map<String, dynamic>> maps = await database.query(
      groceryTable,
      columns: [
        idColumn,
        nameColumn,
        valueColumn,
        oldValueColumn,
        imgColumn,
        typeColumn,
        isSelectedColumn,
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return GroceryItem.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> deleteGroceryItem(int id) async {
    Database database = await db;
    return await database.delete(
      groceryTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updateGroceryItem(GroceryItem groceryItem) async {
    Database database = await db;
    return await database.update(
      groceryTable,
      groceryItem.toMap(),
      where: "$idColumn = ?",
      whereArgs: [groceryItem.id],
    );
  }

  Future<List<GroceryItem>> getAllGroceryItems() async {
    Database database = await db;
    List<Map<String, dynamic>> listGroceryItemsMap = await database.rawQuery(
      "SELECT * FROM $groceryTable",
    );
    List<GroceryItem> listGroceryItems = [];
    for (Map<String, dynamic> map in listGroceryItemsMap) {
      listGroceryItems.add(GroceryItem.fromMap(map));
    }
    return listGroceryItems;
  }

  Future<int?> getGroceryItemCount() async {
    Database database = await db;
    return Sqflite.firstIntValue(
      await database.rawQuery("SELECT COUNT(*) FROM $groceryTable"),
    );
  }

  Future<void> closeDb() async {
    Database database = await db;
    database.close();
  }
}

class GroceryItem {
  int? id;
  late String name;
  late String value;
  String oldValue = "0.00";
  String? img;
  late String type;
  int isSelected = 0;

  GroceryItem({required this.name, required this.value, required this.type});

  GroceryItem.fromMap(Map map) {
    id = map[idColumn];
    name = map[nameColumn];
    value = map[valueColumn];
    oldValue = map[oldValueColumn];
    img = map[imgColumn];
    type = map[typeColumn] ?? 'grocery';

    final selectedValue = map[isSelectedColumn];
    if (selectedValue is int) {
      isSelected = selectedValue;
    } else if (selectedValue is String) {
      isSelected = int.tryParse(selectedValue) ?? 0;
    } else {
      isSelected = 0;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      idColumn: id,
      nameColumn: name,
      valueColumn: value,
      oldValueColumn: oldValue,
      imgColumn: img,
      typeColumn: type,
      isSelectedColumn: isSelected,
    };
  }

  @override
  String toString() {
    return 'GroceryItem(id: $id, name: $name, value: $value, oldValue: $oldValue, img: $img, type: $type, isSelected: $isSelected)';
  }
}
