import 'statistic_database_creator.dart';
import '../models/stat.dart';
class StatDBInteract {
  static Future <List<Stat>> getStatistics(int type) async {
    final sql = '''
    SELECT * FROM ${StatDBCreator.tableName}
    WHERE ${StatDBCreator.type} = $type
    ''';
    final data = await db1.rawQuery(sql);
    List<Stat> list = List();
    for (final element in data) {
      list.add(Stat.fromJSON(element));
    }
    return list;
  }

  static Future<void> upDateVocabRem(int type, int key) async
  {
    final sql = '''
    UPDATE ${StatDBCreator.tableName}
    SET ${StatDBCreator.remember} = ${StatDBCreator.remember} + 1
    WHERE ${StatDBCreator.type} = $type AND ${StatDBCreator.key} = $key
    ''';
    await db1.rawQuery(sql);
    return;
  }

  static Future<void> upDateVocab(int type, int key) async
  {
    final sql = '''
    UPDATE ${StatDBCreator.tableName}
    SET ${StatDBCreator.vocabs} = ${StatDBCreator.vocabs} + 1 
    WHERE ${StatDBCreator.type} = $type AND ${StatDBCreator.key} = $key 
    ''';
    return;
  }

  static Future<void> resetDB(int type) async
  {
    final sql = '''
    UPDATE ${StatDBCreator.tableName}
    SET ${StatDBCreator.remember} = 0 
    WHERE ${StatDBCreator.type} = $type  
    ''';
    return;
  }

  static Future<void> insertToDB(int id, int type, int key, int rem,
      int vocabs) async
  {
    String sql = '''
    INSERT INTO ${StatDBCreator.tableName} (
      ${StatDBCreator.id},
      ${StatDBCreator.type},
      ${StatDBCreator.key},
      ${StatDBCreator.remember},
      ${StatDBCreator.vocabs}
    ) VALUES
    (?,?,?,?,?)
    ''';
    db1.execute(sql, [id, type, key, rem, vocabs]);
    return;
  }

  static Future<void> printDB() async{
    String sql = '''
    SELECT * FROM ${StatDBCreator.tableName}
    ''';
    final data = await db1.rawQuery(sql);
    for(final node in data)
      {
        print(node['id']);
        print(node['type']);
        print(node['key']);
        print(node['vocabs']);
        print(node['remember']);
        print('end Record');
      }
    return;
  }
}
//  static Future<int> todosCount() async {
//    final data = await db1
//        .rawQuery('SELECT MAX(id) FROM ${StatDBCreator.tableName}');
//    int count = data[0].values.elementAt(0);
//    print(idForNewItem);
//    print("checkPoint!");
//    return idForNewItem;
//  }

