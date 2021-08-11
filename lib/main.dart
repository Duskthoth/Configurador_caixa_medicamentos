// @dart=2.9

import 'package:caixa_remedio_2/views/bluetoothOff.dart';
import 'package:caixa_remedio_2/views/findDevice.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Caixa de Medicamentos",
        theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.teal,
            secondaryHeaderColor: Colors.white,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        //Decide se o bluetooth está ligado ou não
        home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              //se estiver apresenta a tela para conectar com a caixa
              return FindDevicesScreen();
            }
            return BluetoothOffScreen(
                state:
                    state); //se não apresenta uma tela de aviso pedindo para que ligue o bluetooth e a localização
          },
        ));
  }
}
