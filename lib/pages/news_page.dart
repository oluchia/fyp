import 'package:flutter/material.dart';
import 'package:fyp/services/rest_calls.dart';
import 'package:fyp/models/news.dart';
import 'package:fyp/pages/news_row.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/utils/progress.dart';
import 'package:fyp/services/root_page.dart';
import 'package:fyp/utils/strings.dart';

class NewsPage extends StatefulWidget {

  @override
  State createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> with SingleTickerProviderStateMixin {
  List<News> newsList = [];
  String schoolId = RootPageState.client.schoolId;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: Theme.of(context).primaryColor,
        bottom: new TabBar(
          controller: controller,
          tabs: <Widget>[
            new Tab(text: 'All'),
            new Tab(text: 'Sports')
          ],
        ),
        title: new Text(
          Strings.newsHeader, 
        )
      ),
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          _buildNewsList(),
          _buildNewsListSports(),
        ],
      ),
    );
  }

  Widget _buildNewsList() {
      return new Container(
        color: Colors.white24,
        child: new StreamBuilder(
          stream: Firestore.instance.collection('news').where("schoolId", isEqualTo: schoolId).snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return MyProgressIndicator();
            } else {
              return new ListView.builder(
                itemExtent: 160.0,
                itemCount: snapshot.data.documents.length, //should change based on db count
                itemBuilder: (_, index) => new NewsRow(_mapToNews(snapshot.data.documents[index])),
              );
            }
          },
        ),
      );
  }

  Widget _buildNewsListSports() {
    return new Container(
      color: Colors.white24,
      child: new StreamBuilder(
        stream: Firestore.instance.collection('news').where("schoolId", isEqualTo: schoolId)
                .where("isSportsNews", isEqualTo: true)
                .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return MyProgressIndicator();
          } else {
            return new ListView.builder(
              itemExtent: 160.0,
              itemCount: snapshot.data.documents.length, //should change based on db count
              itemBuilder: (_, index) => new NewsRow(_mapToNews(snapshot.data.documents[index])),
            );
          }
        },
      ),
    );
  }

  Object _mapToNews(DocumentSnapshot doc) {
    return News.fromMap(doc.data, doc.documentID);
  }
}