import 'package:flutter_test/flutter_test.dart';
import 'package:fyp/models/client.dart';
import 'package:flutter/material.dart';

void main() {
  const docData = {
    "data" : {
      "name" : "High School",
      "theme" : {
        "primaryColor" : "#FFFFFF",
        "secondaryColor" : "#000000",
      },
      "social" : {
        "hasFacebook" : true,
      },
      "schoolId" : "1002",
    },
    "documentID" : "1",
  };

  group('Client', () {
    test('Document data should be mapped as Client obj', () {
      Client client = Client(schoolId: "1002");
      client = Client.fromMap(docData["data"], docData["documentID"]);

      expect(client.name, 'High School'); //test for Strings
      expect(client.social.hasFacebook, true); //test for Maps
      expect(client.theme.primaryColor, Color(0xFFFFFFFF)); //test for Maps & helper methods
    });

    test('String should be converted to Color obj', () {
      Color color = Client.hexToColor("#FFFFFF");
      expect(color, Color(0xFFFFFFFF));
    });
  });
}