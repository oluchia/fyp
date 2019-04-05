import 'package:flutter/material.dart';
import 'package:fyp/models/event.dart';
import 'package:fyp/services/rest_calls.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:fyp/services/root_page.dart';
import 'package:intl/intl.dart';
import 'package:fyp/utils/strings.dart';

class EventsPage extends StatefulWidget {

  @override
  State createState() => EventsPageState();
}

class EventsPageState extends State<EventsPage> {
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();
  DateTime _currentDate = DateTime.now();

  bool _hasEvent;
  List<EventType> widgets = new List<EventType>();

  String schoolId = RootPageState.client.schoolId;
  EventList<EventType> _markedDateMap = new EventList<EventType>();

  @override
  void initState() {
    super.initState();

    _hasEvent = false;

    getAllEvents(schoolId).then((list) {
      setState(() {
        for(EventType event in list) {
           _markedDateMap.add(
              //not sure why this is needed but an error occurs otherwise
              new DateTime(event.startDate.year, event.startDate.month, event.startDate.day), 
              event);
        }
      });
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
          Strings.eventHeader)
      ),
      body: new SingleChildScrollView(
        child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _calendar(),
                _hasEvent ? new Container(
                  child: new ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widgets.length,
                    itemBuilder: (context, index) => _listItemBuilder(context, index),
                  )
                ) : new Container(),
              ],
        ),
      ) 
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
          this.setState(() => _currentDate = date);
      
          if(events.isNotEmpty) {
            _hasEvent = true;
            this.setState(() => widgets = events);
          } else {
            _hasEvent = false;
          }
          
        },
      ),
    );
  }

  Widget _listItemBuilder(BuildContext context, int index) {
    return _eventCard(widgets[index].title, widgets[index].description, widgets[index].location, 
                      widgets[index].startDate, widgets[index].endDate);
  }

  Widget _eventCard(String title, String description, String location, DateTime startDate, DateTime endDate) {
    DateFormat formatter = new DateFormat('jm');
    Event event = new Event(
      title: title,
      description: description,
      startDate: startDate,
      endDate: endDate,
      location: location,
      allDay: false
    );

    return new Container(
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
                title,
                style: new TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold)
              ),
              subtitle: new Text(description),
              
            ),
            new Container(
              color: const Color(0xFF00C6FF),
              width: 350.0,
              height: 1.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
            ),
            new Padding(padding: EdgeInsets.only(top: 4.0)),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(left: 16.0)),
                new Icon(Icons.timer, color: Colors.grey),
                new Padding(padding: EdgeInsets.only(right: 16.0)),
                new Text(formatter.format(startDate) + " - "),
                new Text(formatter.format(endDate))
              ],
            ),
            new Padding(padding: EdgeInsets.only(bottom: 4.0)),
            new Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(padding: EdgeInsets.only(left: 16.0)),
                new Icon(Icons.location_on, color: Colors.grey),
                new Padding(padding: EdgeInsets.only(right: 16.0)),
                new Text(location)
              ],
            ),
            new ButtonTheme.bar(
              child: new ButtonBar(
                children: <Widget>[
                  new FlatButton(
                    child: const Text('ADD TO CALENDAR'),
                    onPressed: () {
                      Add2Calendar.addEvent2Cal(event).then((success) {
                         // Error surfaces if starDateTime is before endDateTime 
                         // or if time extends to next day
                        scaffoldState.currentState.showSnackBar(
                          new SnackBar(content: new Text(success ? 'Success' : 'Error'), 
                                       backgroundColor: Theme.of(context).primaryColor));
                      }).catchError((e) {
                        return 0;
                      });
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}