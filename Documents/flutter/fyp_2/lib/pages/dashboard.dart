import 'package:flutter/material.dart';
import 'package:fyp/pages/events_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/models/client.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/pages/contactUs_page.dart';
import 'package:fyp/pages/home_page.dart';
import 'package:fyp/pages/settings_page.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({Key key, this.client, this.auth, this.userId, this.onSignedOut, this.onAccountDeleted}) :
    super(key: key);
  
  final Client client;
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final VoidCallback onAccountDeleted;
  final String userId;

  @override
  State createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashboardPage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    ContactUsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    _children.add(SettingsPage(onAccountDeleted: _accountDeleted));

    return new Scaffold(
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: Colors.blue,
        title: new Text(
          widget.client.name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 30.0
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(FontAwesomeIcons.signOutAlt),
            tooltip: 'Log out',
            onPressed: () {
              _signOut();
            }
          )
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return new BottomNavigationBar(
      onTap: _onBarItemTapped,
      currentIndex: _currentIndex,
      items: [
        new BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text("Home"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.contact_phone),
          title: new Text("Contact Us"),
        ),
        new BottomNavigationBarItem(
          icon: new Icon(Icons.settings),
          title: new Text("Settings"),
        )
      ],
    );
  }

  void _onBarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _accountDeleted() async {
    try {
      await widget.auth.deleteAccount();
      widget.onAccountDeleted();
    } catch (e) {
      print(e);
    }
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
}