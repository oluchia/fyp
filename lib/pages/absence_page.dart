import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hello_world/utils/progress.dart';
import 'package:hello_world/utils/crm_utils.dart';
import 'package:hello_world/services/authentication.dart';
import 'package:hello_world/services/rest_calls.dart';
import 'package:hello_world/models/absence_form.dart';

class AbsencePage extends StatefulWidget {
  AbsencePage({this.auth});

  final BaseAuth auth;

  @override
  State createState() => AbsencePageState();
}

class AbsencePageState extends State<AbsencePage> {
  final _formKey = GlobalKey<FormState>();

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

  List<String> _numDays = <String>['', '1 day', '2 days'];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Report Absence'),
      ),
      body: new ListView(
        children: <Widget>[
          new Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          new Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi tristique malesuada ante, nec aliquam tortor.',
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
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

  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Icon(icon, color: color),
        new Container(
          margin: const EdgeInsets.only(top: 8.0),
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

      print(_userEmail);

      if(_userEmail != null && _userEmail.length > 0) {
        _newForm.name = "Absence of ${_studentName} in year ${_yearGroup} and class ${_class}";
        _newForm.description = "Contact number of Parent / Guardian ${_contactNumber.toString()}. Reason for absence: ${_reason}";

        postNoteToCRM(_userEmail, _newForm);

        Navigator.of(context).pushNamed('/home');

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

  @override
  void initState() {
    super.initState();
    _isLoading = false;

    widget.auth.getCurrentUserEmail().then((email) {
      if(email != null) {
        _userEmail = email;
      }
    });
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

    return new Form(
      key: _formKey,
      autovalidate: true,
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
      return ProgressIndicatior();
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