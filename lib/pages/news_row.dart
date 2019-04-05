import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:fyp/models/news.dart';
import 'package:fyp/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      decoration: news.imageUrl.isNotEmpty ? BoxDecoration(
        shape: BoxShape.circle,
        image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(news.imageUrl),
        )
      ) : null, //modification for test
    );

    final newsCard = new Container(
      margin: const EdgeInsets.only(left: 72.0, right: 24.0),
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColorDark,
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
              style: Theme.of(context).textTheme.title,
              textDirection: TextDirection.ltr, //modification made for test
            ),
            new Text(news.author, 
              style: Theme.of(context).textTheme.caption,
              textDirection: TextDirection.ltr
            ),
            new Container(
              color: Colors.white,
              width: 24.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
            ),
            new Padding(padding: EdgeInsets.only(bottom: 12.0)),
            new Row(
              children: <Widget>[
                new Text(news.date, style: Theme.of(context).textTheme.caption),
              ],
            )
          ],
        ),
      )
    );

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
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
      )
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