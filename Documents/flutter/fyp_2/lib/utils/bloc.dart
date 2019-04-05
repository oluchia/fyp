import 'package:flutter/material.dart';
import 'dart:async';

class Bloc {
  final _themeController = StreamController<bool>();
  get changeTheme => _themeController.sink.add;
  get initialTheme => _themeController.stream;
}