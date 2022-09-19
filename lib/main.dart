import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter/foundation.dart' as foundation;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isNear = false;
  bool hasflashlight = false;
  bool isturnon = false;

  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    listenSensor();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> _ligaLanterna(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      print('error enabling torch light');
    }
  }

  Future<void> _desligaLanterna(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      print('error disabling torch light');
    }
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        print('is near? ${_isNear}');
        if (_isNear == false) {
          _desligaLanterna(context);
        }

        if (_isNear == true) {
          Vibration.vibrate(
            duration: 1500,
            amplitude: 128,
          );

          _ligaLanterna(context);
        }
      });
    });
  }

  Image bixao() {
    return const Image(
      image: AssetImage('assets/images/demogorgon.jpg'),
    );
  }

  Image menina() {
    return const Image(
      image: AssetImage('assets/images/eleven.jpg'),
    );
  }

  Image mostraImagens() {
    if (_isNear == true) {
      return menina();
    } else {
      return bixao();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("coisas estranhas"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            children: [
              mostraImagens(),
            ],
          ),
        ),
      ),
    );
  }
}
