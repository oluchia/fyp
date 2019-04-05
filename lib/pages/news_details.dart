import 'package:flutter/material.dart';
import 'package:fyp/models/news.dart';
import 'package:fyp/services/rest_calls.dart';

class NewsDetailPage extends StatefulWidget {
  NewsDetailPage(String id) :
    this.id = id;

  final String id;

  @override
  State createState() => new NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  @override
  Widget build(BuildContext context) {
    Widget appBar = new Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top
      ),
      child: new Row(
        children: <Widget>[
          new BackButton(
            color: Colors.white
          )
        ],
      ),
    );

    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildBody(),
          appBar,
      ],
      ),
    );
  }

  Widget _buildBody() {
    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.blueAccent,
          child: new FutureBuilder(
            future: getById(widget.id),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(!snapshot.hasData) return LinearProgressIndicator();

              News news = snapshot.data;

              return _getContent(news);
            },
          ),
        )
      ],
    );
  }

  Widget _newsThumbnail(News news) {
    return new Center(
      child: new Container(
        height: 100.0,
        width: 100.0,
        decoration: news.imageUrl.isNotEmpty ? BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.fill,
            image: new NetworkImage(news.imageUrl),
          )
        ) : null, //modification for test
      ),
    );
  }

  Widget _newsValue(News news, {String value}) {
    return new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(width: 8.0),
          new Text(news.date, style: Theme.of(context).textTheme.caption),
        ],
      ),
    );
  }

  static Widget _divider = new Container(
    margin: new EdgeInsets.symmetric(vertical: 8.0),
    height: 2.0,
    width: 18.0,
    color: Colors.grey,
  );

  Widget _newsCardContent(News news) {
    return new Container(
    margin: new EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 16.0),
    constraints: new BoxConstraints.expand(),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(height: 4.0),
        new Text(news.title, style: Theme.of(context).textTheme.title),
        new Text(news.author, style: Theme.of(context).textTheme.caption),
        _divider,
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Expanded(
              flex: 0,
              child: _newsValue(
                news,
                value: news.date,
              ),
            )
          ],
        ),
      ],
    ),
  );
  }


  Widget _newsCard(News news) {
    return new Container(
    child: _newsCardContent(news),
    height: 154.0,
    margin: EdgeInsets.only(top: 72.0),
    decoration: new BoxDecoration(
      color: Colors.white12,
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: [
        new BoxShadow(
          color: Colors.black12,
          blurRadius: 10.0,
          offset: new Offset(0.0, 10.0),
        )
      ]
    ),
  );
  }

  Widget _mainBody(News news) {
    return new Container(
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0
      ),
      child: new Stack(
        children: <Widget>[
          _newsCard(news),
          _newsThumbnail(news),
        ],
      ),
    );
  }

  Widget _getContent(News news) {
    final _title = "Description".toUpperCase();
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          _mainBody(news),
          new Container(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_title, style: Theme.of(context).textTheme.display1),
                _divider,
                new Text(news.description, style: Theme.of(context).textTheme.body1)
              ],
            ),
          )
        ],
      ),
    );
  }
}