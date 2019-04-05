import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fyp/services/root_page.dart';
import 'package:fyp/models/client.dart';
import 'package:fyp/utils/strings.dart';

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  final Client client = RootPageState.client;

  @override
  Widget build(BuildContext context) {
    return new Column(
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
          padding: const EdgeInsets.only(top: 5.0),
        ),
        new Expanded(
          flex: 7,
          child: new StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              _buildTile(eventsChild, onTap: () => _changePage('/events')),
              _buildTile(absenteeChild, onTap: () => _changePage('/absence')),
              _buildTile(newsChild, onTap: () => _changePage('/newsPage')),
              _buildTile(webChild, onTap: () => launch(client.website)),
              _buildTile(infoChild),
            ],
            staggeredTiles: [
              StaggeredTile.extent(1, 175.0),
              StaggeredTile.extent(1, 175.0),
              StaggeredTile.extent(2, 110.0),
              StaggeredTile.extent(1, 175.0),
              StaggeredTile.extent(1, 175.0),
            ],
          ),
        )
      ],
    );
  }

  void _changePage(String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  Widget eventsChild = new Padding(
    padding: EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Colors.red,
            shape: CircleBorder(),
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Icon(Icons.event, color: Colors.white, size: 30.0),
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(bottom: 16.0),
          ),
          new Text(
            Strings.eventHeader,
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

  Widget newsChild = new Padding(
    padding: EdgeInsets.all(24.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                Strings.newsHeader,
                style: new TextStyle(
                  color: Colors.amberAccent,
                ),
              ),
              new Text(
                'All, Sports',
                style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.0
                )
              ),
            ],
          ),
          new Material(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(24.0),
            child: new Center(
              child: new Padding(
                padding: EdgeInsets.all(16.0),
                child: new Icon(FontAwesomeIcons.newspaper, color: Colors.white, size: 30.0),
              ),
            )
          ),
        ],
      )
  );

  Widget webChild = new Padding(
    padding: EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Colors.teal,
            shape: CircleBorder(),
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Icon(FontAwesomeIcons.globe, color: Colors.white, size: 30.0),
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(bottom: 16.0),
          ),
          new Text(
            'Website',
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24.0
            ),
          ),
        ],
      ),
  );

  Widget absenteeChild = new Padding(
    padding: EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Colors.green,
            shape: CircleBorder(),
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Icon(FontAwesomeIcons.userTimes, color: Colors.white, size: 30.0),
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(bottom: 16.0),
          ),
          new Text(
            Strings.absenteeHeader,
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24.0
            ),
          ),
        ],
      ),
  );

  Widget infoChild = new Padding(
    padding: EdgeInsets.all(24.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Material(
            color: Colors.blue,
            shape: CircleBorder(),
            child: new Padding(
              padding: EdgeInsets.all(16.0),
              child: new Icon(Icons.info, color: Colors.white, size: 30.0),
            ),
          ),
          new Padding(
              padding: EdgeInsets.only(bottom: 16.0),
          ),
          new Text(
            Strings.infoHeader,
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24.0
            ),
          ),
          new Text(
            'School Info',
            style: new TextStyle(
              color: Colors.black45
            )
          )
        ],
      ),
  );

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
      elevation: 14.0,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Colors.blueAccent,
      child: InkWell(
        // do onTap() if it isn't null otherwise print
        onTap: onTap != null ? () => onTap() : () {
          print("Not yet set");
        },
        child: child,
      ),
    );
  }
}