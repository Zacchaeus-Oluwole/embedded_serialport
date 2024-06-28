<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# embedded_serialport

`embedded_serialport` is a Flutter package for serial port communication, it uses Dart FFI (Foreign Function Interface) to interact with Rust and C shareable libraries. This package provides a simple API to list available serial ports and perform read/write operations.

## Platform Support
- Linux

## Features

- List available serial ports
- Open and configure serial ports
- Read from and write to serial ports
- Set timeouts for serial communication

## Installation

To install `embedded_serialport`, use either `flutter pub add` or `dart pub add`, depending on your project type:

### Flutter

```bash
flutter pub add embedded_serialport
```
### Dart

```bash
dart pub add embedded_serialport
```

## Dependencies

#### For GNU/Linux `pkg-config` headers are required:

- Ubuntu: `sudo apt install pkg-config`
- Fedora: `sudo dnf install pkgconf-pkg-config`

For other distros they may provide `pkg-config` through the `pkgconf` package instead.

#### For GNU/Linux `libudev` headers are required as well (unless you disable the default `libudev` feature):

- Ubuntu: `sudo apt install libudev-dev`
- Fedora: `sudo dnf install systemd-devel`

## Check for Permissions:
- Linux: Ensure your user is part of the `dialout` group or equivalent.

  ```bash
  sudo usermod -aG dialout $USER
  ```
  Then log out and log back in.

Without setting your user to be part of the `dialout`, you will receive this error:  `SerialErrorCode.serialErrorOpen`

## NB: Prepare Linux apps for distribution
To build flutter applciation as release run the following command:
```bash
flutter build linux --release
```
After that, go to **build/linux/release/bundle/** and run the application using the following command:
```bash
./projectname
```
"_By runnung the application in the directory, a file will be automatically copied to **lib** folder with the following directory **src/rust_native/librust_serialport.so**. This file is responsible for this library to work in your application._"

## Usage
Import the package in your Dart code:
```dart
import 'package:embedded_serialport/embedded_serialport.dart';
```

## Example 1: Listing Available Serial Ports
```dart
import 'package:embedded_serialport/embedded_serialport.dart';

void main() {
  List<String> ports = Serial.getPorts();
  // print(ports.where((x) => x.endsWith("USB0")));
  print(ports);
  for (int i = 0; i < ports.length; i++) {
    print(ports[i]);
  }
}

```
## Example 2: Communicating with a Serial Device
```dart
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

```
## API
`Serial`
### Static Methods
- `List<String> getPorts()`
  - Returns a list of available serial ports.
### Constructor
- `Serial(String port, Baudrate baudrate)`
  - Creates a new instance of Serial for the specified port and baud rate.
### Methods
- `void timeout(int seconds)`
  - Sets a timeout for read/write operations.
- `void writeString(String data)`
  - Writes a string to the serial port.
- `Uint8List read(int length)`
  - `Reads a specified number of bytes from the serial port.`
- `void dispose()`
  - Closes the serial port and releases resources.

### `Baudrate`
Enumeration of common baud rates:

- `Baudrate.b9600`
- `Baudrate.b19200`
- `Baudrate.b38400`
- `Baudrate.b57600`
- `Baudrate.b115200`
- And more...

## Author
### Zacchaeus Oluwole

LinkedIn: <https://www.linkedin.com/in/zacchaeus-oluwole/>

X: <https://x.com/ZTechPlus>

Email: <zacchaeusoluwole@gmail.com>

Github: <https://github.com/Zacchaeus-Oluwole>


## Credit
### Peter Sauer <https://flutterdev.at/dart_periphery/>