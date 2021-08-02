import 'package:caixa_remedio_2/constants/theme_data.dart';
import 'package:caixa_remedio_2/helper/alarm_helper.dart';
import 'package:caixa_remedio_2/models/medicamento_info.dart';
import 'package:caixa_remedio_2/views/listaMedicamentos.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String _horaMedicamentoString;
  late DateTime _horaMedicamento = DateTime.now();
  AlarmHelper _alarmHelper = AlarmHelper();
  late TextEditingController _nomeControle = TextEditingController();

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_horaMedicamento.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _horaMedicamento;
    else
      scheduleAlarmDateTime = _horaMedicamento.add(Duration(days: 1));

    var medicamentoInfo = MedicamentoInfo(
      gradienteColorIndex: 2,
      nome: 'Diovan',
      posicaoCaixa: 14,
      vezesAoDia: 3,
      horarios: [DateFormat("HH:MM").format(scheduleAlarmDateTime)],
    );
    _alarmHelper.insertAlarm(medicamentoInfo);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.pageBackgroundColor,
        centerTitle: true,
        title: Text(
          "Lista de Medicamentos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(child: ListaMedicamentos()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _horaMedicamentoString = DateFormat('HH:mm').format(DateTime.now());
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
                              _horaMedicamento = selectedDateTime;
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
                            title: Row(
                              children: [
                                Expanded(child: Text('Nome do Medicamento')),
                                Expanded(
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Preencha este campo';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.name,
                                    controller: _nomeControle,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        alignLabelWithHint: true,
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        labelText: 'Nome do Medicamento'),
                                  ),
                                ),
                              ],
                            ),
                            trailing: FaIcon(FontAwesomeIcons.pills)),
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
    );
  }
}
