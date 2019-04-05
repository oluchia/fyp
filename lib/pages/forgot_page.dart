import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hello_world/services/authentication.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage({this.auth});

  final BaseAuth auth;

  @override
  State createState() => new PasswordPageState();
}

class PasswordPageState extends State<PasswordPage> {
  final controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldState = new GlobalKey();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldState,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(24.0),
              child: new TextField(
                controller: controller,
                decoration: new InputDecoration(
                  hintText: 'Please enter your email',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () async {
          widget.auth.passwordReset(controller.text);
          scaffoldState.currentState.showSnackBar(
            new SnackBar(
              content: new Text("A password reset email was sent to ${controller.text}"),
              backgroundColor: Colors.blueAccent,
              duration: new Duration(seconds: 2),
            )          
          );
          await new Future.delayed(const Duration(seconds: 3));
          Navigator.of(context).pop();
        },
        tooltip: 'Send reset email',
        child: new Icon(Icons.check),
      ),
    );
  }
}