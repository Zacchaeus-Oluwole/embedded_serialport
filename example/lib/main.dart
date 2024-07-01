import 'package:flutter/material.dart';
import 'package:embedded_serialport/embedded_serialport.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serial Port Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SerialPortPage(),
    );
  }
}

class SerialPortPage extends StatefulWidget {
  const SerialPortPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SerialPortPageState createState() => _SerialPortPageState();
}

class _SerialPortPageState extends State<SerialPortPage> {
  late Serial _serial;
  List<String> _ports = [];
  String _output = "";

  @override
  void initState() {
    super.initState();
    _initializeSerialPort();
  }

  void _initializeSerialPort() {
    _ports = Serial.getPorts();
    if (_ports.isNotEmpty) {
      _serial = Serial(_ports.first, Baudrate.b115200);
      _serial.timeout(2);
    }
  }

  void _writeString(String command) async {
    _serial.writeString(command);
    await Future.delayed(const Duration(milliseconds: 100));
    var event = _serial.read(0);
    setState(() {
      _output += "Hardware says -> ${event.toString()}\n";
    });
  }

  void _disposeSerialPort() {
    _serial.dispose();
  }

  @override
  void dispose() {
    _disposeSerialPort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serial Port Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Available Ports: ${_ports.join(", ")}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _writeString('on'),
              child: const Text('Send "on"'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _writeString('off'),
              child: const Text('Send "off"'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
