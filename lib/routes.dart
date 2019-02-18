import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:hello_world/pages/login_page.dart';
import 'package:hello_world/pages/dashboard.dart';
import 'package:hello_world/pages/events_page.dart';
import 'package:hello_world/pages/absence_page.dart';
import 'package:hello_world/pages/news_page.dart';
import 'package:hello_world/services/authentication.dart';
import 'package:hello_world/services/root_page.dart';
import 'package:hello_world/pages/news_details.dart';
import 'package:hello_world/pages/forgot_page.dart';

class Routes {

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
    runApp(new MaterialApp (
      title: 'FYP',
      routes: routes,
      home: new RootPage(auth: new Auth()),
    ));
  }
}

