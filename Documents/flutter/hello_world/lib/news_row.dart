import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:hello_world/models/news.dart';
import 'package:hello_world/routes.dart';

class NewsRow extends StatelessWidget {
  final News news;

  NewsRow(this.news);

  @override
  Widget build(BuildContext context) {
    final newsThumbnail = new Container(
      alignment: new FractionalOffset(0.0, 0.5),
      margin: const EdgeInsets.only(left: 24.0, top: 20.0),
      height: 100.0,
      width: 100.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(news.imageUrl),
        )
      ),
    );

    final newsCard = new Container(
      margin: const EdgeInsets.only(left: 72.0, right: 24.0),
      decoration: new BoxDecoration(
        color: Colors.deepPurpleAccent,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black,
            blurRadius: 10.0,
            offset: new Offset(0.0, 1.0)
          )
        ]
      ),
      child: new Container(
        margin: const EdgeInsets.only(top: 16.0, left: 72.0),
        constraints: new BoxConstraints.expand(),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(news.title, 
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24.0
              )
            ),
            new Text(news.author, 
              style: new TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0
              )
            ),
            new Container(
              color: Colors.green,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
            ),
          ],
        ),
      )
    );

    return new Container(
      height: 120.0,
      margin: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: new FlatButton(
        onPressed: () => _navigateTo(context, news.id),

        child: new Stack(
          children: <Widget>[
            newsCard,
            newsThumbnail
          ],
        ),
      ),
    );
  }

  void _navigateTo(context, String id) {
    Routes.navigateTo(
      context,
      '/newsDetail/$id',
      transition: TransitionType.fadeIn
    );
  }
}