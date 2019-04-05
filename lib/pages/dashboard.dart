import 'package:flutter/material.dart';
import 'package:hello_world/pages/events_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/services/authentication.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DashboardPage extends StatefulWidget {

  DashboardPage({Key key, this.auth, this.userId, this.onSignedOut}) :
    super(key: key);
  
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State createState() => DashBoardPageState();
}

class DashBoardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: Colors.blue,
        title: new Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 30.0
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: new Icon(FontAwesomeIcons.solidUserCircle),
            tooltip: 'Profile',
            onPressed: () {
              _signOut();
            }
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            flex: 3,
            child: new Image.asset(
              'assets/images/campus.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          new Expanded(
            flex: 7,
            child: new StaggeredGridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              children: <Widget>[
                _buildTile(),
                _buildTile(),
                _buildTile(),
                _buildTile()
              ],
              staggeredTiles: [
                StaggeredTile.extent(1, 200.0),
                StaggeredTile.extent(1, 200.0),
                StaggeredTile.extent(1, 200.0),
                StaggeredTile.extent(1, 200.0),
              ],
            ),
          )
        ],
      ),
      drawer: _buildSideMenu(),
    );
  }

  Widget _buildSideMenu() {
    return new Drawer(
      child: new ListView(
        children: <Widget>[
          new DrawerHeader(
            child: new Text("School Name"),
            decoration: BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/images/image.png"),
                fit: BoxFit.cover,
              )
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.home),
            title: Text("Placeholder 1"),
            onTap: () {
              Navigator.pop(context); //closes drawer
              _changePage('/events');
            },
          ),
          new ListTile(
            title: new Text("Placeholder 2"),
            onTap: () {
              Navigator.pop(context);
              _changePage('/absence');
            }
          ),
          new ListTile(
            title: new Text("Placeholder 3"),
            onTap: () {
              Navigator.pop(context);
              _changePage('/newsPage');
            }
          ),
        ],
      ),
    );
  }

  void _changePage(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget _buildTile({Function() onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Colors.blueAccent,
      child: InkWell(
        // do onTap() if it isn't null otherwise print
        onTap: onTap != null ? () => onTap() : () {
          print('Not yet set');
        },
        child: _buildChild(),
      ),
    );
  }

  //should be amended to be customizable
  Widget _buildChild() {
    return new Padding(
      padding: EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Colors.amber,
            shape: CircleBorder(),
            child: new Padding(
              padding: EdgeInsets.all(24.0),
              child: new Icon(Icons.event, color: Colors.white, size: 30.0),
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(bottom: 16.0),
          ),
          new Text(
            'Events',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24.0
            ),
          ),
          new Text(
            'All',
            style: new TextStyle(
              color: Colors.black45
            )
          )
        ],
      ),
    );
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