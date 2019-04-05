import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fyp/utils/progress.dart';
import 'package:fyp/models/user.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/services/rest_calls.dart';
import 'package:fyp/models/absence_form.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AbsencePage extends StatefulWidget {
  AbsencePage({this.auth});

  final BaseAuth auth;

  @override
  State createState() => AbsencePageState();
}

class AbsencePageState extends State<AbsencePage> {
  final _formKey = GlobalKey<FormState>();

  FirebaseUser _user;
  String _userId = '';
  String _userEmail = '';
  bool _isLoading;

  String _studentName;
  String _yearGroup;
  String _class;
  int _contactNumber;
  String _daysAbsent;
  String _reason;

  AbsenceForm _newForm = new AbsenceForm();
  String textValue = 'Sup';
  List<String> _numDays = <String>['', '1 day', '2 days', '3 days'];

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Log Absence'),
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          new Text(
            'If absence of student is predicted to be longer than 3 days, please contact the school directly',
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
          new Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          _buildButtons(),
          _buildForm(),
          _showProgressIndicator()
        ],
      ),
    );
  }

  void _helper(String label) {
    print(label);
    CloudFunctions.instance.call(
      functionName: 'addToCRM',
      parameters: {
        "label" : label,
        "email" : _userEmail,
      }
    );
  }

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new IconButton(icon: new Icon(icon), color: color, onPressed: () => {
          _helper(label)
        }),
        new Container(
          child: new Text(
            label,
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: color
            ),
          )
        ),
      ]
    );
  }

  void _validateAndSubmit() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      setState(() {
        _isLoading = true;
      });

      if(_userEmail != null && _userEmail.length > 0) {
        _newForm.name = "Absence of ${_studentName} in year ${_yearGroup} and class ${_class}";
        _newForm.description = "Contact number of Parent / Guardian ${_contactNumber.toString()}. Reason for absence: ${_reason}";

        postNoteToCRM(_userEmail, _newForm).then((msg) {
          if(msg == 'success') {
            Note note = new Note(dateAdded: new DateTime.now().toIso8601String(), 
                                description: _reason, type: Type.ABSENCE.toString().split('.').last);
            User user = new User(id: _user.uid, email: _userEmail, note: note, token: textValue);
            updateUserInFirebaseCollection(user);

          }
        });

        Navigator.of(context).pop();

      } else {
        _showDialog();
      }

    } 
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Error Message"),
          content: new Text("Not logged in"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Try Again"),
              onPressed: () =>
                Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void firebaseCloudMessagingListeners() {
    if(Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      update(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> msg) async {
        print('on message $msg');
        showNotification(msg);
      },
      onResume: (Map<String, dynamic> msg) async {
        print('on resume $msg');
      },
      onLaunch: (Map<String, dynamic> msg) async {
        print('on launch $msg');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
    );

    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print('Settings registered: $settings');
    });
  }

  void update(String token) {
    print(token);
    setState(() {
      textValue = token;
    });
  }

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    firebaseCloudMessagingListeners();

    AndroidInitializationSettings android = new AndroidInitializationSettings('mipmap/image');
    IOSInitializationSettings ios = new IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings platform = new InitializationSettings(android, ios);

    flutterLocalNotificationsPlugin.initialize(platform);

    widget.auth.getCurrentUser().then((user) {
      if(user.uid != null) {
        _user = user;
        _userEmail = user.email;
      }
    });
  }

  void showNotification(Map<String, dynamic> msg) async {
    AndroidNotificationDetails android = new AndroidNotificationDetails('fyp', 'school', 'notification_channel');
    IOSNotificationDetails ios = new IOSNotificationDetails();
    NotificationDetails platform = new NotificationDetails(android, ios);

    await flutterLocalNotificationsPlugin.show(0, msg["notification"]["title"], msg["notification"]["body"], platform);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    print('Enters here');
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(title),
        content: new Text(body),
        actions: <Widget>[
          new CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      )
    );
  }

  Widget _buildButtons() {
    Color color = Theme.of(context).primaryColor;

    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildButtonColumn(color, Icons.call, 'CALL'),
          _buildButtonColumn(color, Icons.mail, 'EMAIL'),
          _buildButtonColumn(color, FontAwesomeIcons.globe, 'WEBSITE'),
        ],
      ),
    );
  }

  Widget _buildForm() {
    Widget studentNameField = new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Student Name',
        fillColor: Colors.white,
        hintText: 'Full name of child',
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Student name can\'t be empty' : null,
      onSaved: (value) => _studentName = value,
    );

    Widget yearGroupField = new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Year Group',
        fillColor: Colors.white,
        hintText: 'ex. 4th class',
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Year group name can\'t be empty' : null,
      onSaved: (value) => _yearGroup = value,
    );

    Widget classField = new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Class',
        fillColor: Colors.white,
        hintText: 'ex. Ms Murphy\'s or JC131',
      ),
      keyboardType: TextInputType.text,
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Class can\'t be empty' : null,
      onSaved: (value) => _class = value,
    );

    Widget contactNumberField = new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Parent or Guardian Contact number' ,
        fillColor: Colors.white,
        hintText: '+353851234678',
      ),
      keyboardType: TextInputType.phone,
      maxLines: 1,
      validator: (value) => value.isEmpty ? 'Class can\'t be empty' : null,
      onSaved: (value) => _contactNumber = int.parse(value),
    );

    Widget reasonTextBox = new TextFormField(
      decoration: new InputDecoration(
        labelText: 'Reason',
        fillColor: Colors.white,
        hintText: 'max. 250 characters',
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      validator: (value) => value.isEmpty ? 'Reason can\'t be empty' : null,
      onSaved: (value) => _reason = value,
    );


    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Form(
        key: _formKey,
        autovalidate: false,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            studentNameField,
            yearGroupField,
            classField,
            contactNumberField,
            _buildDropdown(),
            reasonTextBox,
            _showButton(),
          ],
        ),
      ),
    );
  }

  Widget _showButton() {
    return new Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: new RaisedButton(
        color: Colors.blue,
        textColor: Colors.white,
        child: const Text('Submit'),
        onPressed: _validateAndSubmit, //to do later - similar to loginpage
      ),
    );
  }

  Widget _showProgressIndicator() {
    if(_isLoading) {
      return MyProgressIndicator();
    } return Container();
  }

  Widget _buildDropdown() {
    return new FormField(
      builder: (FormFieldState state) {
        return new InputDecorator(
          decoration: new InputDecoration(
            labelText: 'Number of Days Absent'
          ),
          isEmpty: _daysAbsent == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: _daysAbsent,
              isDense: true,
              onChanged: (String value) {
                setState(() {
                  _daysAbsent = value;
                  state.didChange(value);                
                });
              },
              items: _numDays.map((String value) {
                return new DropdownMenuItem(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}