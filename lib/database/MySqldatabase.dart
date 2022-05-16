import 'package:mysql1/mysql1.dart';

class MySqldatabase {
  ConnectionSettings cxs = new ConnectionSettings(
      host: '127.0.0.1',
      port: 3306,
      user: 'root',
      // password: "6KTuCruBFa",
      db: 'flutter_db');

  user_select(String sql, List para) async {
    List _data = [];
    Map<String, dynamic> _sdata = {};
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    Results results = await cx.query(sql, para);
    _data.clear();
    for (var item in await results) {
      _sdata = {
        "ID_USER": item[0],
        "NAME": item[1],
        "LASTNAME": item[2],
        "EMAIL": item[3],
        "PASSWORD": item[4]
      };
      _data.add(_sdata);
      _sdata = {};
    }
    cx.close();
    return _data;
  }

  note_select(String sql, List para) async {
    List _data = [];
    Map<String, dynamic> _sdata = {};
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    Results results = await cx.query(sql, para);
    _data.clear();
    for (var item in await results) {
      _sdata = {
        "ID_NOTE": item[0],
        "TITRE": item[1],
        "NOTE": item[2],
        "ID_USER": item[3]
      };
      _data.add(_sdata);
      _sdata = {};
    }
    cx.close();
    return _data;
  }

  insert(String sql, List para) async {
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    Results results = await cx.query(sql, para);
    cx.close();
    return results.insertId;
  }

  Future update(String sql, List para) async {
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    await cx.query(sql, para);
    cx.close();
  }

  Future delete(String sql, List para) async {
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    await cx.query(sql, para);
    cx.close();
  }

  createTableUSER() async {
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    await cx.query(
        "CREATE TABLE IF NOT EXISTS user (ID_USER INT PRIMARY KEY AUTO_INCREMENT,NAME VARCHAR(10) NOT NULL,LASTNAME VARCHAR(10) NOT NULL,EMAIL VARCHAR(30) NOT NULL,PASSWORD VARCHAR(12) NOT NULL)");
    cx.close();
  }

  createTableNote() async {
    MySqlConnection cx = await MySqlConnection.connect(cxs);
    Results results = await cx.query(
        "CREATE TABLE IF NOT EXISTS note (ID_NOTE INT PRIMARY KEY AUTO_INCREMENT,TITRE VARCHAR(20) NOT NULL,NOTE TEXT NOT NULL,ID_USER INT,FOREIGN KEY (ID_USER) REFERENCES user(ID_USER))");
    cx.close();
    return results.insertId;
  }
}
