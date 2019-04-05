import 'package:fyp/routes.dart';
import 'package:flutter/services.dart';

void main() {

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    new Routes();
  });

}
