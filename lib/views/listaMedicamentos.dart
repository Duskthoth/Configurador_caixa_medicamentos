import 'package:caixa_remedio_2/constants/theme_data.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:caixa_remedio_2/helper/alarm_helper.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:caixa_remedio_2/models/medicamento_info.dart';
import 'dart:async';

import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:intl/intl.dart';

class ListaMedicamentos extends StatefulWidget {
  @override
  _ListaMedicamentosState createState() => _ListaMedicamentosState();
}

class _ListaMedicamentosState extends State<ListaMedicamentos> {
  DateTime _horasMedicamento = DateTime.now();
  String _horaMedicamentoString = '';
  AlarmHelper _alarmHelper = AlarmHelper();
  late Future<List<MedicamentoInfo>> _medicamentos;
  List<MedicamentoInfo> _medicamentosAtuais = [];

  @override
  void initState() {
    _alarmHelper.initializeDatabase().then((value) {
      print("--------Database Inicialized");
    });
    loadMedicamentos();
    super.initState();
  }

  Future<void> loadMedicamentos() async {
    _medicamentos = _alarmHelper.getMedicamentos();

    _medicamentosAtuais = await _medicamentos;
    if (mounted) {
      setState(() {});
      print('Medicamentos carregados');
    }
  }

  void deleteMedicamento(int id) async {
    await _alarmHelper.delete(id);
    await loadMedicamentos();
  }

  /*void onSaveAlarm() async {
    DateTime scheduleAlarmDateTime;
    if (_horasMedicamento.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _horasMedicamento;
    else
      scheduleAlarmDateTime = _horasMedicamento.add(Duration(days: 1));

    var medicamentoInfo = MedicamentoInfo(
      gradienteColorIndex: 1,
      nome: 'Diovan',
      posicaoCaixa: 14,
      vezesAoDia: 3,
      horarios: [DateFormat("HH:MM").format(scheduleAlarmDateTime)],
    );
    await _alarmHelper.insertAlarm(medicamentoInfo);

    Navigator.pop(context);
    await loadMedicamentos();
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => loadMedicamentos(),
              child: ListView.builder(
                itemCount: _medicamentosAtuais.length,
                itemBuilder: (BuildContext context, int index) {
                  var gradientColor = GradientTemplate
                      .gradientTemplate[
                          _medicamentosAtuais[index].gradienteColorIndex]
                      .colors;
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColor,
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gradientColor.last.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.label,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  _medicamentosAtuais[index].nome,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'avenir'),
                                ),
                              ],
                            ),
                            Switch(
                              value: true,
                              onChanged: (bool value) {},
                              activeColor: Colors.white,
                            ),
                          ],
                        ),
                        Text(
                          "Posição: " +
                              _medicamentosAtuais[index]
                                  .posicaoCaixa
                                  .toString(),
                          style: TextStyle(
                              color: Colors.white, fontFamily: 'avenir'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _medicamentosAtuais[index].horarios[0],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'avenir',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.white,
                              onPressed: () {
                                deleteMedicamento(
                                    _medicamentosAtuais[index].id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          /*     FloatingActionButton(
            onPressed: () {
              _horaMedicamentoString =
                  DateFormat('HH:mm').format(DateTime.now());
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                var selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (selectedTime != null) {
                                  final now = DateTime.now();
                                  var selectedDateTime = DateTime(
                                      now.year,
                                      now.month,
                                      now.day,
                                      selectedTime.hour,
                                      selectedTime.minute);
                                  _horasMedicamento = selectedDateTime;
                                  setModalState(() {
                                    _horaMedicamentoString = DateFormat('HH:mm')
                                        .format(selectedDateTime);
                                  });
                                }
                              },
                              child: Text(
                                _horaMedicamentoString,
                                style: TextStyle(fontSize: 32),
                              ),
                            ),
                            ListTile(
                              title: Text('Nome'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            ListTile(
                              title: Text('Sound'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            ListTile(
                              title: Text('Title'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            FloatingActionButton.extended(
                              onPressed: onSaveAlarm,
                              icon: Icon(Icons.alarm),
                              label: Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
              // scheduleAlarm();
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.blueGrey,
          ),
      */
        ],
      ),
    );
  }
}
