import 'package:flutter/material.dart';
import 'package:fyp/ui/text_style.dart';
import 'package:fyp/services/root_page.dart';

ThemeData buildTheme() {

  //probably need to be configured manually
  //final theme = RootPageState.client.theme;
  // int secondaryColor = int.parse(theme["primaryColor"]);

  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      headline: Style.headerTextStyle,
      title: Style.titleTextStyle,
      caption: base.caption.copyWith(
        color: Colors.blue,
      ),
      body1: Style.commonTextStyle
    );
  }

  final ThemeData base = ThemeData.light();

  return base.copyWith(
    //the below colors should be retrived from the database somehow
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: const Color(0xFF1B9469),
    indicatorColor: const Color(0xFFB62123),
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    accentColor: const Color(0xFFFFF8E1),
    iconTheme: new IconThemeData(
      color: Colors.blue,
      size: 20.0
    ),
    buttonColor: Colors.white,
    backgroundColor: Colors.white,
    tabBarTheme: base.tabBarTheme.copyWith(
      labelColor: const Color(0xFF807A6B),
      unselectedLabelColor: Colors.blue,
    )
  );
}