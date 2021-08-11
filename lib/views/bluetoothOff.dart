import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, required this.state}) : super(key: key);
  final BluetoothState state;
  @override
  Widget build(BuildContext context) {
    //constroe tela de aviso que o bluetooth está desligado
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Por favor ligue o bluetooth e a localização do celular.\n' +
                  'Bluetooth Adapter is ${state.toString().substring(15)}.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .primaryTextTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
