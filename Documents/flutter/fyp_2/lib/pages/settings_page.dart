import 'package:flutter/material.dart';
import 'package:fyp/services/authentication.dart';
import 'package:fyp/utils/bloc.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.auth, this.onAccountDeleted}) :
    super(key: key);
  
  final BaseAuth auth;
  final VoidCallback onAccountDeleted;

  @override
  State createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final bloc = Bloc();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Change application theme"),
            trailing: new Switch(
                value: isSwitched,
                // onChanged: bloc.changeTheme,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
            ),
          ),  
          new ListTile(
            title: new Text("Submit feedback"),
          ), 
          new Divider(color: Colors.red),
          new RawMaterialButton(
            padding: EdgeInsets.all(2.0),
            onPressed: () => _showDialog(), 
            child: new Center(
              child: new Text("Delete Account", style: new TextStyle(color: Colors.red)),
            ),
          ), 
          new Divider(color: Colors.red),   
        ],
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Delete Account ?"),
          content: new Text("This will delete your account"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel".toUpperCase()),
              onPressed: () =>
                Navigator.of(context).pop(),
            ),
            new FlatButton(
              child: new Text("Accept".toUpperCase()),
              onPressed: () {
                widget.onAccountDeleted();
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      },
    );
  }
}