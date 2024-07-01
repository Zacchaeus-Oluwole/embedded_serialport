// dart_library.dart

import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

import 'package:path/path.dart' as path;

String getLibraryPath() {
  final String pubCacheDir = path.join(
    Platform.environment['HOME']!,
    '.pub-cache',
    'hosted',
    'pub.dev',
    'embedded_serialport-1.5.5',
    'lib',
    'src',
  );
  // Construct the full path to the shared library
  final String sourceLibPath =
      path.join(pubCacheDir, 'rust_native', 'librust_serialport.so');

  // Construct the destination path
  final executableDir = path.dirname(Platform.resolvedExecutable);
  final destinationLibPath = path.join(
      executableDir, 'lib', 'src', 'rust_native', 'librust_serialport.so');

  if (!File(destinationLibPath).existsSync()) {
    // Create the destination directories if they do not exist
    final destinationDir = path.dirname(destinationLibPath);
    Directory(destinationDir).createSync(recursive: true);
    // Copy the file to the new location
    File(sourceLibPath).copySync(destinationLibPath);
  }

  // Verify if the file exists at the new location
  if (File(destinationLibPath).existsSync()) {
    return destinationLibPath;
  } else {
    throw Exception('Failed to copy the library to $destinationLibPath');
  }
}

final DynamicLibrary rustLib = Platform.isLinux
    ? DynamicLibrary.open(
        getLibraryPath()) // Update with the actual name of the compiled Rust library
    : DynamicLibrary.process();

// ignore: camel_case_types
typedef ports_func = Pointer<Utf8> Function();
typedef Ports = Pointer<Utf8> Function();

// ignore: camel_case_types
typedef free_ports_string_func = Void Function(Pointer<Utf8>);
typedef FreePortsString = void Function(Pointer<Utf8>);

final Ports portsFromRust =
    rustLib.lookup<NativeFunction<Ports>>("get_ports").asFunction<ports_func>();

final FreePortsString freePortsString = rustLib
    .lookupFunction<free_ports_string_func, FreePortsString>('free_get_ports');
