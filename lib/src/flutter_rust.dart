// dart_library.dart

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'package:path/path.dart' as path;

String getLibraryPath() {
  // Determine the location of the .pub-cache directory
  final String pubCacheDir = path.join(
    Platform.environment['HOME']!,
    '.pub-cache',
    'hosted',
    'pub.dev',
    'embedded_serialport-0.0.39',
    'lib',
    'src',
    'rust_native',
  );

  // Construct the full path to the shared library
  final String libPath = path.join(pubCacheDir, 'librust_serialport.so');

  if (File(libPath).existsSync()) {
    return libPath;
  } else {
    throw Exception('Library not found at $libPath');
  }
}


final DynamicLibrary rustLib = Platform.isLinux
    ? DynamicLibrary.open(getLibraryPath()) // Update with the actual name of the compiled Rust library
    : DynamicLibrary.process();

// ignore: camel_case_types
typedef ports_func = Pointer<Utf8> Function();
typedef Ports = Pointer<Utf8> Function();

// ignore: camel_case_types
typedef free_ports_string_func = Void Function(Pointer<Utf8>);
typedef FreePortsString = void Function(Pointer<Utf8>);

final Ports portsFromRust = rustLib.lookup<NativeFunction<Ports>>("get_ports")
    .asFunction<ports_func>();

final FreePortsString freePortsString = rustLib
    .lookupFunction<free_ports_string_func, FreePortsString>('free_get_ports');