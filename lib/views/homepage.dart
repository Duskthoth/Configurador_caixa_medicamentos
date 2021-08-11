import 'package:caixa_remedio_2/constants/theme_data.dart';
import 'dart:convert';
import 'package:caixa_remedio_2/helper/alarm_helper.dart';
import 'package:caixa_remedio_2/models/medicamento_info.dart';
import 'package:caixa_remedio_2/views/listaMedicamentos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({required this.disp});
  final BluetoothDevice disp;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late String _horaMedicamentoString;
  late DateTime _horaMedicamento = DateTime.now();
  AlarmHelper _alarmHelper = AlarmHelper();
  late var _nomeControle = TextEditingController();
  late var _vezesControle = TextEditingController();
  late var _posicaoCaixaControle = TextEditingController();

  Widget _gerarTextFields(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 15,
        ),
        //Area nome Remedio
        TextFormField(
          style: TextStyle(color: Colors.white),
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
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: CustomColors.minHandStatColor)),
              icon: FaIcon(
                FontAwesomeIcons.pills,
                color: CustomColors.minHandStatColor,
              ),
              alignLabelWithHint: true,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
              labelText: 'Nome do Medicamento',
              labelStyle: TextStyle(color: CustomColors.minHandStatColor)),
        ),
        SizedBox(
          height: 15,
        ),
        Flexible(
          //Quantidade de Comprimidos
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha este campo';
              }
              return null;
            },
            controller: _posicaoCaixaControle,
            maxLength: 2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                icon: FaIcon(FontAwesomeIcons.th,
                    color: CustomColors.minHandStatColor),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        BorderSide(color: CustomColors.minHandStatColor)),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                labelText: "Posição Na caixa",
                labelStyle: TextStyle(color: CustomColors.minHandStatColor)),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Flexible(
          //Vezes ao dia de utilização do medicamento
          child: TextFormField(
            style: TextStyle(color: Colors.white),
            maxLength: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Preencha este campo';
              }
              return null;
            },
            keyboardType: TextInputType.number,
            controller: _vezesControle,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                icon: FaIcon(
                  FontAwesomeIcons.calendarAlt,
                  color: CustomColors.minHandStatColor,
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        BorderSide(color: CustomColors.minHandStatColor)),
                counterText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                labelText: "Vezes ao Dia",
                labelStyle: TextStyle(color: CustomColors.minHandStatColor)),
          ),
        )
      ],
    );
  }

  int _determinarCor() {
    if (_horaMedicamento.hour <= 12) {
      return 3;
    } else if (_horaMedicamento.hour <= 18) {
      return 1;
    } else {
      return 0;
    }
  }

  void onSaveAlarm() {
    DateTime scheduleAlarmDateTime;
    if (_horaMedicamento.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _horaMedicamento;
    else
      scheduleAlarmDateTime = _horaMedicamento.add(Duration(days: 1));

    var medicamentoInfo = MedicamentoInfo(
      gradienteColorIndex: _determinarCor(),
      nome: _nomeControle.text,
      posicaoCaixa: int.tryParse(_posicaoCaixaControle.text),
      vezesAoDia: int.tryParse(_vezesControle.text),
      horarios: [DateFormat("HH:MM").format(scheduleAlarmDateTime)],
    );
    medicamentoInfo.geraHorarios(scheduleAlarmDateTime);
    _alarmHelper.insertAlarm(medicamentoInfo);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Salvo!')));
    Navigator.pop(context);

    _nomeControle.clear();
    _posicaoCaixaControle.clear();
    _vezesControle.clear();

    _pegaCaracteristicasEEscreveNoDispositivo(
        widget.disp, medicamentoInfo.sendToDevice());
  }

  void _pegaCaracteristicasEEscreveNoDispositivo(
      BluetoothDevice disp, String data) async {
    var bluetoothCharacteristic;
    List<BluetoothService> services = await disp.discoverServices();
    services.forEach((service) {
      print("${service.uuid}");
      List<BluetoothCharacteristic> blueChar = service.characteristics;
      blueChar.forEach((f) {
        print("Characteristice =  ${f.uuid}");
        if (f.uuid
                .toString()
                .compareTo("00000052-0000-1000-8000-00805f9b34fb") ==
            0) {
          bluetoothCharacteristic = f;
          print(true);
        }
      });
    });

    bluetoothCharacteristic.write(utf8.encode(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.menuBackgroundColor,
      appBar: AppBar(
        backgroundColor: CustomColors.pageBackgroundColor,
        centerTitle: true,
        title: Text(
          "Lista de Medicamentos",
          style: TextStyle(color: Colors.white),
        ),
      ),
      //constroe a lista dos medicamentos já cadastrados
      body: Center(child: ListaMedicamentos(widget.disp)),

      //botao para cadastramento de novo medicamento
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _horaMedicamentoString = DateFormat('HH:mm').format(DateTime.now());
          //apresenta um formulario para preenchimento e cadastramento do medicamento
          showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: CustomColors.menuBackgroundColor,
            elevation: 40,
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
                        Text(
                          "Escolha um horario:",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                              elevation: 30,
                              primary: CustomColors.minHandStatColor),
                          onPressed: () async {
                            var selectedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (selectedTime != null) {
                              var now = DateTime.now();
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
                        Form(
                            key: _formKey,
                            child: Expanded(
                              child: _gerarTextFields(context),
                            )),
                        FloatingActionButton.extended(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              onSaveAlarm();
                            }
                          },
                          backgroundColor: CustomColors.clockBG,
                          icon: FaIcon(FontAwesomeIcons.clock),
                          label: Text('Salvar'),
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
        backgroundColor: CustomColors.clockBG,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: CustomColors.pageBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
    );
  }
}
