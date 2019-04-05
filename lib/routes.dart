import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:fyp/pages/login_page.dart';
import 'package:fyp/pages/dashboard.dart';
import 'package:fyp/pages/events_page.dart';
import 'package:fyp/pages/absence_page.dart';
import 'package:fyp/pages/news_page.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/services/root_page.dart';
import 'package:fyp/pages/news_details.dart';
import 'package:fyp/pages/forgot_page.dart';
import 'package:fyp/pages/settings_page.dart';
import 'package:fyp/utils/bloc.dart';

class Routes {
  final bloc = Bloc();
  static final Router _router = new Router();

  final routes = <String, WidgetBuilder>{
    '/auth' : (BuildContext context) => new LoginPage(),
    '/events' : (BuildContext context) => new EventsPage(),
    '/home' : (BuildContext context) => new DashboardPage(),
    '/absence' : (BuildContext context) => new AbsencePage(auth: new Auth()),
    '/newsPage' : (BuildContext context) => new NewsPage(),
    '/forgotPassword' : (BuildContext context) => new PasswordPage(auth: new Auth()),
  };

  static var newsDetailHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return new NewsDetailPage(params['id'][0]);
    });

  static void initRoutes() {
    _router.define("/newsDetail/:id", handler: newsDetailHandler);
  }

  static void navigateTo(context, String route, {TransitionType transition}) {
    _router.navigateTo(context, route, transition: transition);
  }

  Routes () {
    Routes.initRoutes();
    runApp(
      new MaterialApp (
            title: 'FYP',
            //theme: SettingsPageState.isSwitched ? ThemeData.light() : ThemeData.dark(),
            routes: routes,
            debugShowCheckedModeBanner: false,
            home: new RootPage(auth: new Auth()),
        ),
    );
  }
}

