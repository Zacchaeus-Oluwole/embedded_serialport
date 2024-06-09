import 'package:embedded_serialport/embedded_serialport.dart';


void main() {

  List<String> ports = Serial.getPorts();
  // print(ports);

  // '/dev/ttyUSB0'
  var s = Serial(ports.first, Baudrate.b115200);
  s.timeout(2);

  try {
    s.writeString('led,0');
    var event = s.read(20);
    print(event.toString());
    s.writeString('led');
    var eventt = s.read(20);
    print(eventt.toString());
  } finally {
    s.dispose();
  }
}