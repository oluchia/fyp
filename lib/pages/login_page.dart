import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:validate/validate.dart';
import 'package:hello_world/utils/progress.dart';
import 'dart:async';
import 'package:hello_world/services/authentication.dart';
import 'package:hello_world/services/rest_calls.dart';

class LoginPage extends StatefulWidget { 
  LoginPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State createState() => new LoginPageState();
}

enum FormMode { LOGIN, SIGNUP }

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  final _formKey = GlobalKey<FormState>();

  FormMode _formMode = FormMode.LOGIN;

  String _email;
  String _password;
  String _errorMessage;
  int _pin;

  bool _isIOS;
  bool _isLoading;

  String _validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return "Please enter a valid email address";
    }
    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 6 ) {
      return 'The Password must be at least six characters long.';
    }
    return null;
  }

  bool _validateAndSave() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async { 
  
    setState(() {
      _isLoading = true;
      _errorMessage = "";
    });

    if(_validateAndSave()) {
      String userId = "";
    
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in user: $userId'); 
        } else {
          final contact = await fetchContactFromCRM(_email);

          if(contact.pin == _pin && contact.email == _email) { 
            userId = await widget.auth.signUp(_email, _password);
            print('Signed up user: $userId'); 
          } else {
            print("User signup error: Not in CRM");
          }    
        }

        setState(() {
          _isLoading = false;
        });

        if(userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }

      } catch (e) {
          print('Error: $e');

          setState(() {
            _isLoading = false;
            if (_isIOS) {
              _errorMessage = e.details;
              _showDialog();
            } else {
              _errorMessage = e.message;
              _showDialog();
            }
          });
      }
    }
  }

  void _formChange() {
    _formKey.currentState.reset();
    _errorMessage = "";

    setState(() {
      if(_formMode == FormMode.LOGIN) {
        _formMode = FormMode.SIGNUP;
      } else {
        _formMode = FormMode.LOGIN;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _errorMessage = "";
    _isLoading = false;

    _iconAnimationController = new AnimationController(
      vsync: this, 
      duration: new Duration(milliseconds: 500));

    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );

    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context){
    _isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          _buildBody(),
          _showProgressIndicator(),
        ],
      ));
  }

  Widget _showProgressIndicator() {
    if(_isLoading) {
      return ProgressIndicatior();
    } return Container();
  }

  Widget _buildBody() {
    return new ListView(
      children: <Widget>[
        new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(30.0),
            child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _showLogo(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showForgotPassword(),
                  _showPinInput(),
                  _showPrimaryButton(),
                  _showSecondaryButton(),
                ],
              ),
            )
          )
        ],
      ),
      ],  
      );
  }

  Widget _showLogo() {
    return new FlutterLogo(
      size: _iconAnimation.value * 140.0,
    );
  }

  Widget _showForgotPassword() {
    return _formMode == FormMode.LOGIN ? new FlatButton(
      child: new SizedBox(
        width: double.infinity,
        child: new Text("Forgot password?", textAlign: TextAlign.right,
                  style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.blue)),
      ),
      onPressed: () => Navigator.of(context).pushNamed('/forgotPassword'),
    ) : Container();
  }

  Widget _showEmailInput() {
    return new TextFormField(
      decoration: new InputDecoration(
        labelText: "Email",
        fillColor: Colors.white,
        hintText: "you@example.com",
        icon: new Icon(
          Icons.mail,
          color: Colors.grey,
        )
      ),
      keyboardType: TextInputType.emailAddress,
      maxLines: 1,
      validator: this._validateEmail,
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _showPasswordInput() {
    return new TextFormField(
      decoration: new InputDecoration(
        labelText: "Password",
        hintText: "password",
        icon: new Icon(
          Icons.lock,
          color: Colors.grey,
        )
      ),
      obscureText: true,
      maxLines: 1,
      keyboardType: TextInputType.text,
      validator: this._validatePassword,
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  Widget _showPinInput() {
    bool visibility = true;

    if(_formMode == FormMode.LOGIN) {
      visibility = false; //hide if Login page
    }

    return visibility ? new TextFormField( 
      decoration: new InputDecoration(
        labelText: "PIN",
        hintText: "12345678",
        icon: new Icon(
          FontAwesomeIcons.key,
          color: Colors.grey,
        )
      ),
      obscureText: true,
      maxLines: 1,
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _pin = int.parse(value);
      },
    ) : new Container();
  }

  Widget _showPrimaryButton() {
    return new Padding(
      padding: EdgeInsets.only(top: 45.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          splashColor: Colors.green,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
          color: Colors.blue,
          child: _formMode == FormMode.LOGIN 
              ? new Text("Login",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))
              : new Text("Create Account",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
          onPressed: _validateAndSubmit,
        ),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text("Don't have an account ? Create one",
                  style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text("Have an account ? Sign in",
                  style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formChange,
    );
  }

  void _showDialog() {
    if(_errorMessage.length > 0 && _errorMessage != null) {
      showDialog(
      context: context,
      builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Error Message"),
            content: new Text(_errorMessage),
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
    } else { 
      return null;
    }
  }
  /*@override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.blue,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/images/image.png"),
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.black87,
          ),
          new Theme(
            data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                labelStyle: new TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 25.0,
                  )
              )
            ),
            isMaterialAppTheme: true,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlutterLogo(
                  size: _iconAnimation.value * 140.0,
                ),
                new Container(
                  padding: const EdgeInsets.all(40.0),
                  child: new Form(
                    key: _formKey,
                    autovalidate: true,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Email",
                            fillColor: Colors.white,
                            hintText: "you@example.com"
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: this._validateEmail,
                          onSaved: (String value) {
                            //this._data.email = value;
                          },
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Password",
                            hintText: "password"
                          ),
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          validator: this._validatePassword,
                          onSaved: (String value) {
                            //this._data.password = value;
                          },
                        ),
                        new Padding(
                          padding: const EdgeInsets.only(top: 60.0),
                        ),
                        new MaterialButton(
                          height: 50.0,
                          minWidth: 150.0,
                          color: Colors.green,
                          splashColor: Colors.teal,
                          textColor: Colors.white,
                          child: new Icon(FontAwesomeIcons.signInAlt),
                          //onPressed: this.submit,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  } */
}