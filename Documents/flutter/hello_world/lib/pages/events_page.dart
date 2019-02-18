import 'package:flutter/material.dart';
import 'package:hello_world/models/event.dart';
import 'package:hello_world/services/rest_calls.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:add_2_calendar/add_2_calendar.dart';

class EventsPage extends StatefulWidget {

  @override
  State createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  DateTime _currentDate = DateTime.now();
  static String _defaultText = "No event here";
  String _calendarText = _defaultText;
  String _description = "";

  bool _hasEvent;
  bool _hasMoreThanOneEvent;

  Widget placeholder;

  Event _event;

  DateTime _startDate;
  DateTime _endDate;

  EventList<EventType> _markedDateMap = new EventList<EventType>(
    events: {
      new DateTime(2019, 2, 14) : [
        new EventType(
          startDate: DateTime(2019, 2, 14),
          title: "Valentine's Day",
          description: "Stupid Holiday"
        )
      ]
    });

  @override
  void initState() {
    super.initState();

    setState(() {
      _hasEvent = false;
      _hasMoreThanOneEvent = false;
    });

    getAllEvents().then((eventsList) { //asyncronous call to Firebase
      for(EventType event in eventsList) {
        _markedDateMap.add(
          //not sure why this is needed but an error occurs otherwise
          new DateTime(event.startDate.year, event.startDate.month, event.startDate.day), 
          event);
      }  
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldState,
      appBar: new AppBar(
        elevation: 2.0,
        backgroundColor: Colors.blue,
        title: new Text(
          "Events")
      ),
      body: new SingleChildScrollView(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _calendar(),
            _eventCard(),
          ],
        ),
      ),
     );
  }

  Widget _calendar() {
    return new Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: new CalendarCarousel<EventType>(
        thisMonthDayBorderColor: Colors.grey,
        height: 430.0,
        selectedDateTime:  _currentDate,
        daysHaveCircularBorder: true,
        markedDatesMap: _markedDateMap,
        weekendTextStyle: new TextStyle(
          color: Colors.red,
        ),
        weekFormat: false,
        onDayPressed: (DateTime date, List<EventType> events) {
          this.setState(() => _showEvent(date));
          //events.forEach((event) => _eventCard(event.title, event.description));
        },
      ),
    );
  }

  void _showEvent(DateTime date) {
    _currentDate = date;
  
    List<EventType> _currentEvents = _markedDateMap.getEvents(new DateTime(date.year, date.month, date.day));

     if(_currentEvents.isNotEmpty) {
      _hasEvent = true;
    
      print('SIZE:  ${_currentEvents.length}');
 
      _calendarText = _currentEvents[0].title;
      _description = _currentEvents[0].description;
      _startDate = _currentEvents[0].startDate;
      _endDate = _currentEvents[0].endDate;

      _event = new Event(
        title: _calendarText,
        description: _description,
        startDate: _startDate,
        endDate: _endDate,
        allDay: false
      );
  
    } else {
      _hasEvent = false;
    }
  }

  Widget _eventCardNum() {
    return new Card(
      child: new Container(
        child: new Padding(
          padding: EdgeInsets.all(16.0),
          child: new Center(
            child: new Text(
              _calendarText,
              style: new TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold)
            ),
          ),
        ),
      ),
    );
  }

  Widget _eventCard() {
    return _hasEvent ? new Container(
      decoration: new BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [ new BoxShadow(
          color: Colors.blueAccent,
          blurRadius: 10.0,
          spreadRadius: 2.0
        )
      ]),
      child: new Card(
        shape: new RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0)
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new ListTile(
              leading: new Icon(Icons.star, size: 40.0, color: Colors.grey),
              title: new Text(
                _calendarText,
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)
              ),
              subtitle: new Text(_description),
              
            ),
            new Container(
              color: const Color(0xFF00C6FF),
              width: 200.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.timer),
                 new Text(_startDate.toString()),
              ],
            ),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Icon(Icons.timer),
                 new Text(_endDate.toString()),
              ],
            ),
            new ButtonTheme.bar(
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('ADD TO CALENDAR'),
                    onPressed: () {
                      Add2Calendar.addEvent2Cal(_event).then((success) {
                        scaffoldState.currentState.showSnackBar(
                          new SnackBar(content: new Text(success ? 'Success' : 'Error')));
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ) : new Container();
  }
}