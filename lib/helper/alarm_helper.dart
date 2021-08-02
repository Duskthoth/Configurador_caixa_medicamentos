// @dart=2.9

import 'package:caixa_remedio_2/models/medicamento_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

final String nomeTabela = 'medicamento';
final String columnId = 'id';
final String columnNome = 'nome';
final String columnHorarios = 'horarios';
final String columnPosicao = 'posicaoCaixa';
final String columnVezes = 'vezesAoDia';
final String columnColorIndex = 'gradientColorIndex';

class AlarmHelper {
  static Database _database;
  static AlarmHelper _alarmHelper;

  AlarmHelper._createInstance();
  factory AlarmHelper() {
    if (_alarmHelper == null) {
      _alarmHelper = AlarmHelper._createInstance();
    }
    return _alarmHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    var dir = await getDatabasesPath();
    var path = dir + "medicamentos.db";

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          create table $nomeTabela ( 
          $columnId integer primary key autoincrement, 
          $columnNome text not null,
          $columnHorarios text not null,
          $columnPosicao integer,
          $columnVezes integer,
          $columnColorIndex integer)
        ''');
      },
    );
    return database;
  }

  Future<void> insertAlarm(MedicamentoInfo medicamento) async {
    var db = await this.database;
    var result = await db.insert(nomeTabela, medicamento.toMap());
    print('result : $result');
  }

  Future<List<MedicamentoInfo>> getMedicamentos() async {
    List<MedicamentoInfo> _medicamentos = [];

    var db = await this.database;
    var result = await db.query(nomeTabela);
    result.forEach((element) {
      var _medicamento = MedicamentoInfo.fromMap(element);
      _medicamentos.add(_medicamento);
    });

    return _medicamentos;
  }

  Future<int> delete(int id) async {
    var db = await this.database;
    return await db.delete(nomeTabela, where: '$columnId = ?', whereArgs: [id]);
  }
}
