import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

void firebaseCloudMessagingListeners() {
  if(Platform.isIOS) iOSPermission();

  _firebaseMessaging.getToken().then((token) {
    print(token);
  });

  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> msg) async {
      print('on message $msg');
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