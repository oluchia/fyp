import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:hello_world/models/news.dart';
import 'package:hello_world/routes.dart';
import 'package:hello_world/services/rest_calls.dart';

class NewsDetailPage extends StatefulWidget {
  NewsDetailPage(String id) :
    this.id = id;

  final String id;

  @override
  State createState() => new NewsDetailPageState();
}

class NewsDetailPageState extends State<NewsDetailPage> {
  //static News specificNews;

  // @override
  // void initState() {
  //   setState(() {
  //     getById(widget.id).then((news) {
  //       specificNews = news;
  //       print("HERE: " + specificNews.schoolID);
  //     });
  //   });
  // }

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
          //_mainBody(),
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

  Widget _newsIcon(News news) {
    return new Center( 
      child: new Hero(
        tag: 'news-icon-${widget.id}',
        child: new Image(
          image: new NetworkImage(news.imageUrl),
          height: 100,
          width: 100,
          
        ),
      ),
    ); 
  }

  static Widget _newsValue(News news, {String value}) {
    return new Container(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(width: 8.0),
          new Text(news.date, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
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

  static Widget _newsCardContent(News news) {
    return new Container(
    margin: new EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 16.0),
    constraints: new BoxConstraints.expand(),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(height: 4.0),
        new Text(news.title, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
        new Container(height: 10.0),
        new Text(news.author, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
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
        new Container(width: 32.0),
        new Expanded(
          flex: 0,
          child: _newsValue(
            news,
            value: news.id
          ),
        )
      ],
    ),
  );
  }
  // static Widget newsCardContent = new Container(
  //   margin: new EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 16.0),
  //   constraints: new BoxConstraints.expand(),
  //   child: new Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: <Widget>[
  //       new Container(height: 4.0),
  //       new Text(specificNews.title, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
  //       new Container(height: 10.0),
  //       new Text(specificNews.author, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
  //       _divider,
  //       new Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           new Expanded(
  //             flex: 0,
  //             child: _newsValue(
  //               value: specificNews.date,
  //             ),
  //           )
  //         ],
  //       ),
  //       new Container(width: 32.0),
  //       new Expanded(
  //         flex: 0,
  //         child: _newsValue(
  //           value: specificNews.id
  //         ),
  //       )
  //     ],
  //   ),
  // );

//   final Widget newsCard = new Container(
//     child: _newsCardContent(),
//     height: 154.0,
//     margin: EdgeInsets.only(top: 72.0),
//     decoration: new BoxDecoration(
//       color: Colors.purple,
//       shape: BoxShape.rectangle,
//       borderRadius: new BorderRadius.circular(8.0),
//       boxShadow: [
//         new BoxShadow(
//           color: Colors.black12,
//           blurRadius: 10.0,
//           offset: new Offset(0.0, 10.0),
//         )
//       ]
//     ),
//   );

  Widget _newsCard(News news) {
    return new Container(
    child: _newsCardContent(news),
    height: 154.0,
    margin: EdgeInsets.only(top: 72.0),
    decoration: new BoxDecoration(
      color: Colors.purple,
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
    print("HERE AGAIN:" + news.author);
    return new Container(
      margin: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 24.0
      ),
      child: new Stack(
        children: <Widget>[
          _newsCard(news),
          _newsIcon(news),
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
                new Text(_title, style: new TextStyle(fontSize: 36.0)),
                _divider,
                new Text(news.description)
              ],
            ),
          )
        ],
      ),
    );
  }
}

// class NewsDetailPage extends StatelessWidget {
//   final String id;

//   NewsDetailPage(String id) :
//     id = id; 
  
//   @override
//   Widget build(BuildContext context) {
//     Widget appBar = new Container(
//       padding: EdgeInsets.only(
//         top: MediaQuery.of(context).padding.top
//       ),
//       child: new Row(
//         children: <Widget>[
//           new BackButton(
//             color: Colors.blue,
//           )
//         ],
//       ),
//     );

//     return new Scaffold(
//       body: new Stack(
//         children: <Widget>[
//           _buildBody(),
//           _mainBody(),
//           appBar,
//       ],
//       ),
//     );
//   }

//   Widget _buildBody() {
//     return new Stack(
//       children: <Widget>[
//         new Container(
//           color: Colors.blueAccent,
//           child: new FutureBuilder(
//             future: getById(id),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if(!snapshot.hasData) return LinearProgressIndicator();
              
//               news = snapshot.data;

//               print(news.author);

//               return new Center( 
//                 child: new Hero(
//                   tag: 'news-icon-$id',
//                   child: new Image(
//                     image: new NetworkImage(news.imageUrl),
//                     height: 100,
//                     width: 100,
//                   )
//                 ),
//               );
//             },
//           ),
//         )
//       ],
//     );
//   }

//   static Widget _newsValue({String value}) {
//     return new Container(
//       child: new Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           new Container(width: 8.0),
//           new Text(news.date, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
//         ],
//       ),
//     );
//   }

//   static Widget _divider = new Container(
//     margin: new EdgeInsets.symmetric(vertical: 8.0),
//     height: 2.0,
//     width: 18.0,
//     color: Colors.grey,
//   );

//   static Widget newsCardContent = new Container(
//     margin: new EdgeInsets.fromLTRB(16.0, 42.0, 16.0, 16.0),
//     constraints: new BoxConstraints.expand(),
//     child: new Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         new Container(height: 4.0),
//         new Text(news.title, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
//         new Container(height: 10.0),
//         new Text(news.author, style: TextStyle(color: Colors.grey, fontSize: 9.0, fontWeight: FontWeight.w400)),
//         _divider,
//         new Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             new Expanded(
//               flex: 0,
//               child: _newsValue(
//                 value: news.date,
//               ),
//             )
//           ],
//         ),
//         new Container(width: 32.0),
//         new Expanded(
//           flex: 0,
//           child: _newsValue(
//             value: news.id
//           ),
//         )
//       ],
//     ),
//   );

//   final Widget newsCard = new Container(
//     child: newsCardContent,
//     height: 154.0,
//     margin: EdgeInsets.only(top: 72.0),
//     decoration: new BoxDecoration(
//       color: Colors.purple,
//       shape: BoxShape.rectangle,
//       borderRadius: new BorderRadius.circular(8.0),
//       boxShadow: [
//         new BoxShadow(
//           color: Colors.black12,
//           blurRadius: 10.0,
//           offset: new Offset(0.0, 10.0),
//         )
//       ]
//     ),
//   );

//   Widget _mainBody() {
//     print(news.author);
//     return new Container(
//       margin: EdgeInsets.symmetric(
//         vertical: 16.0,
//         horizontal: 24.0
//       ),
//       child: new Stack(
//         children: <Widget>[
//           newsCard,
//         ],
//       ),
//     );
//   }
// }