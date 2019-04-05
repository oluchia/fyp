import 'package:flutter/material.dart';
import 'package:hello_world/services/rest_calls.dart';
import 'package:hello_world/models/news.dart';
import 'package:hello_world/news_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/utils/progress.dart';

class NewsPage extends StatefulWidget {

  @override
  State createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        _buildAppBar(),
        _buildNewsList(),
      ],
    );
  }

  Widget _buildNewsList() {
    return new Flexible(
      child: new Container(
        color: Colors.purple,
        child: new StreamBuilder(
          stream: Firestore.instance.collection('news').snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return ProgressIndicatior();
            } else {
              return new ListView.builder(
                itemExtent: 160.0,
                itemCount: snapshot.data.documents.length, //should change based on db count
                itemBuilder: (_, index) => new NewsRow(_mapToNews(snapshot.data.documents[index])),
              );
            }
          },
        ),
      ),
    );
  }

  Object _mapToNews(DocumentSnapshot doc) {
    return News.fromMap(doc.data, doc.documentID);
  }

  Widget _buildAppBar() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return new Container(
      padding: new EdgeInsets.only(top: statusBarHeight),
      height: statusBarHeight + 66.0,
      child: new Center(
        child: new Text(
          "News",
          style: new TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 36.0
          ),
        ),
      ),
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.blue, Colors.indigo],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.5, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
        )
      ),
    );
  }


}