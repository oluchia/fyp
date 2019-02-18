import 'package:flutter/material.dart';
import 'package:hello_world/utils/progress.dart';
import 'package:hello_world/services/authentication.dart';
import 'package:hello_world/pages/dashboard.dart';
import 'package:hello_world/pages/login_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State createState() => _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if(user != null) {
          _userId = user?.uid; //get id only if user is not null
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(auth: widget.auth, onSignedIn: _onLoggedIn);
        break;
      case AuthStatus.LOGGED_IN:
        if(_userId.length > 0 && _userId != null) {
          return new DashboardPage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut
          );
        } else return _buildWaitingScreen();
        break;
      default: 
        return _buildWaitingScreen();
    }
  }

  Widget _buildWaitingScreen() {
    return new Scaffold(
      body: new Container(
        alignment: Alignment.center,
        child: new ProgressIndicatior(),
      ),
    );
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

}