import 'package:flutter/material.dart';
import 'package:fyp/utils/progress.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/services/rest_calls.dart';
import 'package:fyp/pages/dashboard.dart';
import 'package:fyp/pages/login_page.dart';
import 'package:fyp/models/client.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State createState() => RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  static Client client;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((user) {      
      setState(() {
        if(user != null) {
          _userId = user?.uid; //get id only if user is not null
          _helperMethod(user);  
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  //may need to be refactored but quick fix is using a progress indicator
  Future _helperMethod(dynamic user) async {
    final contact = await fetchContactFromCRM(user?.email);
    final temp = await getClientByName(contact.companyName);
  
    setState(() {
      client = temp;
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
        if(_userId.length > 0 && _userId != null && client != null) {
          return new DashboardPage(
            client: client,
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            onAccountDeleted: _onAccountDeleted,
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
        child: new MyProgressIndicator(),
      ),
    );
  }

  void _onSignedOut() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _onAccountDeleted() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  void _onLoggedIn() {
    widget.auth.getCurrentUser().then((user) {
      _helperMethod(user); 
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

}