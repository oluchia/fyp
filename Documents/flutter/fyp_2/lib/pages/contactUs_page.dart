import 'package:flutter/material.dart';
import 'package:fyp/models/client.dart';
import 'package:fyp/services/root_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  GoogleMapController mapController;
  static Client client = RootPageState.client;

  static final LatLng _center = LatLng(client.geoPoint.latitude, client.geoPoint.longitude);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final String mailTo = "mailto:<" + client.email + ">?subject=<subject>&body=<body>";
  final String tel = "tel:" + client.phone;

  Set<Marker> markers = new Set<Marker>();
  Marker target = new Marker(
                    markerId: new MarkerId("schoolLocation"), 
                    infoWindow: new InfoWindow(
                      title: client.name
                    ),
                    position: _center);

  @override
  Widget build(BuildContext context) {
    markers.add(target);
    print(client.phone);
    return new Container(
      child: new Column(
        children: <Widget>[
          new Expanded(
            flex: 6,
            child: new Container(
              child: new GoogleMap(
                onMapCreated: _onMapCreated,
                markers: markers,
                initialCameraPosition: new CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
              ),
            ),
          ),
          new Padding(padding: const EdgeInsets.only(top: 16.0)),
          new Expanded(
            flex: 4,
            child: new ListView(
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    //new Padding(padding: const EdgeInsets.only(top: 8.0)),
                    client.social.hasFacebook ? IconButton(
                      icon: new Icon(
                              FontAwesomeIcons.facebookSquare, 
                              size: 50.0,
                              color: Theme.of(context).primaryColor
                      ),
                      onPressed: () => client.social.hasFacebook ? 
                                       launch(client.social.facebookUrl): print("not yet set"), //placeholder
                    ) : new Container(),
                    client.social.hasTwitter ? IconButton(
                      icon: new Icon(
                              FontAwesomeIcons.twitterSquare, 
                              size: 50.0,
                              color: Theme.of(context).primaryColor
                      ),
                      onPressed: () => client.social.hasTwitter ?
                                       launch(client.social.twitterUrl) : print("not yet set"), //placeholder
                    ) : new Container(),
                    client.social.hasInstagram ? IconButton(
                      icon: new Icon(
                              FontAwesomeIcons.instagram, 
                              size: 50.0,
                              color: Theme.of(context).primaryColor
                      ),
                      onPressed: () => client.social.hasInstagram ?
                                       launch(client.social.instagramUrl) : print("not yet set"), //placeholder
                    ) : new Container(),
                  ],
                ),
                new Padding(padding: const EdgeInsets.only(top: 24.0)),
                new ListTile(
                  leading: new Icon(Icons.location_on, size: 30.0),
                  title: new Text(client.address),
                ),
                new ListTile(
                  leading: new Icon(Icons.email, size: 30.0),
                  title: new Text(client.email),
                  onTap: () => launch(mailTo),
                ),
                new ListTile(
                  leading: new Icon(Icons.phone, size: 30.0),
                  title: new Text(client.phone),
                  onTap: () => launch(tel),
                ),
              ],
            ),     
          )
        ],
      ),
    );
  }
}