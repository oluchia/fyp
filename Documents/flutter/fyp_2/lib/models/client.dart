import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String id;
  final String name;
  final String address;
  final String schoolId;
  final String email;
  final String phone;
  final String website;
  final GeoPoint geoPoint;
  final ThemeType theme;
  final Social social;

  const Client({this.id, this.name, this.address, this.schoolId, 
               this.email, this.phone, this.website,
               this.geoPoint, this.theme, this.social}) : assert(schoolId != null);

  Client.fromMap(Map<String, dynamic> data, String id) : this(
    id: id,
    name: data['name'],
    address: data['address'],
    schoolId: data['schoolId'],
    email: data['email'],
    phone: data['phone'],
    website: data['website'],
    geoPoint: data['location'],
    theme: _getTheme(data['theme']),
    social: _getSocial(data['social']),
  );

  static Social _getSocial(Map<dynamic, dynamic> data) {
    if(data == null) {
      return null;
    }

    Social temp = new Social(hasFacebook: data["hasFacebook"], hasTwitter: data["hasTwitter"],
                             hasInstagram: data["hasInstagram"], instagramUrl: data["instagramUrl"],
                             facebookUrl: data["facebookUrl"], twitterUrl: data["twitterUrl"]);
    return temp;
  }

  static ThemeType _getTheme(Map<dynamic, dynamic> data) {
    if(data == null) {
      return null;
    }

    ThemeType temp = new ThemeType(primaryColor: hexToColor(data["primaryColor"]), 
                                  secondaryColor: hexToColor(data["secondaryColor"]));
    return temp;
  }

  static Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1,7), radix: 16) + 0xFF000000);
  }
}

class ThemeType {
  final Color primaryColor;
  final Color secondaryColor;

  const ThemeType({this.primaryColor, this.secondaryColor});
}

class Social {
  final bool hasFacebook;
  final bool hasTwitter;
  final bool hasInstagram;
  final String facebookUrl;
  final String instagramUrl;
  final String twitterUrl;

  const Social({this.hasFacebook, this.hasInstagram, this.hasTwitter, 
                this.facebookUrl, this.instagramUrl, this.twitterUrl});
}