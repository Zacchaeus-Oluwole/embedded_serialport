import 'package:embedded_serialport/embedded_serialport.dart';

void main() {
  List<String> ports = Serial.getPorts();
  // print(ports.where((x) => x.endsWith("USB0")));
  print(ports);
  for (int i = 0; i < ports.length; i++){
    print(ports[i]);
  }
}