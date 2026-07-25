import 'package:flutter/material.dart';

class AppLifecycleTracker with WidgetsBindingObserver {
  static final AppLifecycleTracker _instance = AppLifecycleTracker._internal();
  bool _isInForeground = true;

  factory AppLifecycleTracker() => _instance;

  AppLifecycleTracker._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  bool get isInForeground => _isInForeground;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = state == AppLifecycleState.resumed;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
