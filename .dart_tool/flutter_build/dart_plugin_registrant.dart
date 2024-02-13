//
// Generated file. Do not edit.
// This file is generated from template in file `flutter_tools/lib/src/flutter_plugins.dart`.
//

// @dart = 2.19

import 'dart:io'; // flutter_ignore: dart_io_import.
import 'package:geolocator_android/geolocator_android.dart';
<<<<<<< HEAD
import 'package:path_provider_android/path_provider_android.dart';
import 'package:sqflite/sqflite.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider_linux/path_provider_linux.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:path_provider_foundation/path_provider_foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider_windows/path_provider_windows.dart';
=======
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
>>>>>>> 115012ed922540f1e069de4da03b93c5a0b3bd4e

@pragma('vm:entry-point')
class _PluginRegistrant {

  @pragma('vm:entry-point')
  static void register() {
    if (Platform.isAndroid) {
      try {
        GeolocatorAndroid.registerWith();
      } catch (err) {
        print(
          '`geolocator_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
<<<<<<< HEAD
        rethrow;
      }

      try {
        PathProviderAndroid.registerWith();
      } catch (err) {
        print(
          '`path_provider_android` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
=======
>>>>>>> 115012ed922540f1e069de4da03b93c5a0b3bd4e
      }

    } else if (Platform.isIOS) {
      try {
        GeolocatorApple.registerWith();
      } catch (err) {
        print(
          '`geolocator_apple` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
<<<<<<< HEAD
        rethrow;
      }

      try {
        PathProviderFoundation.registerWith();
      } catch (err) {
        print(
          '`path_provider_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isLinux) {
      try {
        PathProviderLinux.registerWith();
      } catch (err) {
        print(
          '`path_provider_linux` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

=======
      }

    } else if (Platform.isLinux) {
>>>>>>> 115012ed922540f1e069de4da03b93c5a0b3bd4e
    } else if (Platform.isMacOS) {
      try {
        GeolocatorApple.registerWith();
      } catch (err) {
        print(
          '`geolocator_apple` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
<<<<<<< HEAD
        rethrow;
      }

      try {
        PathProviderFoundation.registerWith();
      } catch (err) {
        print(
          '`path_provider_foundation` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

      try {
        SqflitePlugin.registerWith();
      } catch (err) {
        print(
          '`sqflite` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

    } else if (Platform.isWindows) {
      try {
        PathProviderWindows.registerWith();
      } catch (err) {
        print(
          '`path_provider_windows` threw an error: $err. '
          'The app may not function as expected until you remove this plugin from pubspec.yaml'
        );
        rethrow;
      }

=======
      }

    } else if (Platform.isWindows) {
>>>>>>> 115012ed922540f1e069de4da03b93c5a0b3bd4e
    }
  }
}
