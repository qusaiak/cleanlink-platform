import 'dart:async';
import 'package:client_app/app.dart';
import 'package:flutter/material.dart';
import 'config/bindings.dart';

Future<void> main() async {
  runZonedGuarded(
    () async {
      await Bindings.init();
      runApp(const MyApp());
    },
    (error, stackTrace) async {
      debugPrint('Error occurred during initialization: $error');
      debugPrint('Stack trace: $stackTrace');
    },
  );
}
