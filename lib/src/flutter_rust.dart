// dart_library.dart

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';


final DynamicLibrary rustLib = Platform.isLinux
    ? DynamicLibrary.open('rust_native/librust_serialport.so') // Update with the actual name of the compiled Rust library
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