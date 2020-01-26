import 'package:exam/Models/item.dart';
import 'package:exam/db_creator.dart';
import 'package:logger/logger.dart';

//TODO: edit field after item appropriately

class DBRep {
  var logger = Logger();

  Future<Item> addItem(Item item) async {
    logger.i("trying to add item to db");
    final sql = '''INSERT INTO ${DBCreator.itemTable}
    (
      ${DBCreator.id},
      ${DBCreator.details},
    ${DBCreator.status},
    ${DBCreator.user},
    ${DBCreator.age},
    ${DBCreator.type}
    )
    VALUES
    (
      ${item.id},
      "${item.details}",
      "${item.status}",
      ${item.user},
      ${item.age},
      "${item.type}"
    )
    ''';
    try {
      await db.rawInsert(sql);
      logger.i("DB: added ${item.id.toString()}");
    } catch (e) {}
    return item;
  }

  Future<int> addId(int id) async {
    logger.i("trying to add item to db");
    final sql = '''INSERT INTO ${DBCreator.subTable}
    (
      ${DBCreator.user},
    )
    VALUES
    (
      $id,
    )
    ''';
    try {
      await db.rawInsert(sql);
      logger.i("DB: user id added $id");
    } catch (e) {}
    return id;
  }

  Future<int> getId() async {
    final sql = '''SELECT * FROM ${DBCreator.subTable}''';
    final data = await db.rawQuery(sql);
    logger.e(data);
    return 0;
  }

  Future<List<Item>> getAllItems() async {
    final sql = '''SELECT * FROM ${DBCreator.itemTable}''';
    final data = await db.rawQuery(sql);
    List<Item> list = List();
    for (var elem in data) {
      Item item = Item.fromJson(elem);
      list.add(item);
    }
    logger.i("DB: get All items");
    return list;
  }

  Future<void> deleteAllItems() async {
    final sql = '''DELETE FROM ${DBCreator.itemTable}''';
    await db.rawDelete(sql);
    logger.i("DB: deleted all items");
  }
}
