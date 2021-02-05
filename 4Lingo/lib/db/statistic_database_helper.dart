
import 'package:fluttericon/octicons_icons.dart';

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
    SET ${StatDBCreator.remember} = 0, ${StatDBCreator.vocabs} = 0 
    WHERE ${StatDBCreator.type} = $type  
    ''';
    await db1.rawUpdate(sql);
    return;
  }

  static Future<void> insertToDB(int id, int type, int key, int rem, int vocabs, int tmp ) async
  {
    String sql = '''
    INSERT INTO ${StatDBCreator.tableName} (
      ${StatDBCreator.id},
      ${StatDBCreator.type},
      ${StatDBCreator.key},
      ${StatDBCreator.remember},
      ${StatDBCreator.vocabs},
      ${StatDBCreator.temp}
    ) VALUES
    (?,?,?,?,?,?)
    ''';
    db1.execute(sql, [id, type, key, rem, vocabs, tmp]);
    return;
  }

  static Future<void> printDB() async {
    String sql = '''
    SELECT * FROM ${StatDBCreator.tableName}
    ''';
    final data = await db1.rawQuery(sql);
    for (final node in data) {
      print(node['id']);
      print(node['type']);
      print(node['key']);
      print(node['remember']);
      print(node['vocabs']);
      print(node['temp']);
      print('end Record');
    }
    return;
  }

//  static Future<int> todosCount() async {
//    final data = await db1
//        .rawQuery('SELECT MAX(id) FROM ${StatDBCreator.tableName}');
//    int count = data[0].values.elementAt(0);
//    print(idForNewItem);
//    print("checkPoint!");
//    return idForNewItem;
//  }

  static Future<void> updateStat() async
  {
    Map<String, String> tmp = {
      'weekday': 'key',
      'day': 'remember',
      'month': 'vocabs',
      'year': 'temp'
    };
    DateTime currentTime = DateTime.now();
    String sql = '''
    SELECT * FROM ${StatDBCreator.tableName}
    WHERE ${StatDBCreator.type} = 4
    ''';
    final data = await db1.rawQuery(sql);
    if(data == null)
    {
      print("NULL");
      return;
    }
    final timeData = data.elementAt(0);

    print("NOT NULL");
    final month = timeData[tmp['month']];
    final year = timeData[tmp['year']];
    final weekday = timeData[tmp['weekday']];
    final day = timeData[tmp['day']];
    DateTime prevTime = new DateTime(year,month,day);
    print(prevTime);
    print(currentTime);

    if(checkSameWeek(prevTime,currentTime) == false) {
      print("Resetting week");
      StatDBInteract.resetDB(0);
    }
      if(month != currentTime.month || year != currentTime.year) {
        StatDBInteract.resetDB(1);
      }
      if(year != currentTime.year) {
        StatDBInteract.resetDB(2);
      }
      String sql2 = '''
      UPDATE ${StatDBCreator.tableName}
      SET  ${StatDBCreator.key} = ${currentTime.weekday}
      ,${StatDBCreator.remember} = ${currentTime.day}
      ,${StatDBCreator.vocabs} = ${currentTime.month}
      , ${StatDBCreator.temp} = ${currentTime.year}
      WHERE ${StatDBCreator.type} = 4
      ''';
      await db1.rawUpdate(sql2);
      return;
    }
  }
  bool checkSameWeek(DateTime a , DateTime b)
  {
    final difference = b.difference(a).inDays;
    print(difference);
    print(b.weekday);
    print(a.weekday);
    if(difference < 7 && b.weekday >= a.weekday && difference >=0)
      return true;
    return false;
  }