import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fyp/utils/contact_utils.dart';
import 'package:fyp/models/contact.dart';
import 'package:fyp/models/absence_form.dart';
import 'package:fyp/models/news.dart';
import 'package:fyp/models/event.dart';
import 'package:fyp/models/client.dart';
import 'package:fyp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';


final Firestore firestore = Firestore();
final CollectionReference userCollection = Firestore.instance.collection('users');

String _username = 'o.anyabuike1@nuigalway.ie';
String _password = 'compsoc123';
String _basicAuth = 'Basic ' + base64Encode(utf8.encode('$_username:$_password')); 

User _fromMap(Map<String, dynamic> data) => new User.fromMap(data);

Widget _buildBody(BuildContext context) {
  return FutureBuilder<List<Contact>>(
    future: fetchContactsFromCRM(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();
      
      return new ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          return _buildListItem(context, snapshot.data[index]);
        },
      );
    },
  );
}

Widget _buildListItem(BuildContext context, Contact data) {
  final contact = data;

  return Padding(
    key: ValueKey(contact.name),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: ListTile(
        title: Text(contact.name),
        trailing: Text(contact.id.toString()),

        onTap: () => Firestore.instance.collection('contacts').document('test')
        .setData({'name': contact.name, 'id' : contact.id}),
      ),
    ),
  );
}

Future<News> getById(String id) async {
  DocumentSnapshot snapshot = await Firestore.instance.collection('news').document(id).get();
  String docId = snapshot.documentID;
  return News.fromMap(snapshot.data, docId);
} 

Future<List<EventType>> getAllEvents(String schoolId) async {
  QuerySnapshot snapshots = await Firestore.instance.collection('events')
                                  .where("schoolId", isEqualTo: schoolId).getDocuments();
  List<EventType> events = [];
  for(DocumentSnapshot doc in snapshots.documents) {
    events.add(EventType.fromMap(doc.data, doc.documentID));
  }
  return events;
}

Future<List<Contact>> fetchContactsFromCRM() async {
  String url = 'https://abstrct-fyp.agilecrm.com/dev/api/contacts?page_size=20';

  final response = await http.get(url, headers: {'authorization': _basicAuth, 'Accept': "application/json"});

  print(response.body);
  List jsonResponse = json.decode(response.body.toString());
  List<Contact> contactList = createContactList(jsonResponse);
  return contactList;
}

Future<Contact> fetchContactFromCRM(String email) async {
  String url = 'https://abstrct-fyp.agilecrm.com/dev/api/contacts/search/email/' + email;

  final response = await http.get(url, headers: {'authorization': _basicAuth, 'Accept': "application/json"});

  Map<String, dynamic> jsonResponse;
  if(response.statusCode == 200 || response.body != '') {
    jsonResponse = jsonDecode(response.body);

    Contact tempContact = new Contact(id: jsonResponse["id"], email: jsonResponse["properties"][5]["value"],
                                    companyName: jsonResponse["properties"][3]["value"], 
                                    pin: int.parse(jsonResponse["properties"][0]["value"]));
    return tempContact;
  } else {
    throw Exception('Failed to retrieve contact');
  }
}

Future<Client> getClientByName(String name) async {
  CollectionReference ref = Firestore.instance.collection('clients');
  QuerySnapshot clientsQuery = await ref.where("name", isEqualTo: name).getDocuments();
                        
  Client client;

  if(clientsQuery.documents.length == 1) {
    clientsQuery.documents.forEach((doc) {
      client = Client.fromMap(doc.data, doc.documentID);
    });
  } else {
    throw Exception("error in Firebase collection");
  }

  return client;
}

Future<void> addUserToFirebaseCollection(FirebaseUser user) async {
  DocumentReference documentReference = userCollection.document(user.uid);
  DocumentSnapshot snapshot;

  return await Firestore.instance.runTransaction((Transaction tx) async {
    try {
       snapshot = await tx.get(documentReference);
       await tx.update(documentReference, snapshot.data);
    } catch (error) {
      if (error is PlatformException &&
          error.code == 'DOCUMENT_NOT_FOUND') {
        await tx.set(documentReference, snapshot.data);
      } else
        rethrow;
    }
    
    if(!snapshot.exists) {
      final User newUser = new User(id: user.uid, email: user.email);
      return userCollection.document(user.uid).setData(newUser.toMap());
    }
  });
}

Future<void> updateUserInFirebaseCollection(User user) async {
  return Firestore.instance.runTransaction((Transaction tx) async {
    final User updatedUser = new User(id: user.id, email: user.email, note: user.note, token: user.token);
    return userCollection.document(updatedUser.id).updateData(updatedUser.toMap());
  });
}

Future<String> postNoteToCRM(String email, AbsenceForm note) async {
  String url = 'https://abstrct-fyp.agilecrm.com/dev/api/contacts/email/note/add';
  
  Map<String, String> jsonData = {
    'email' : email,
    'note' : json.encode(note.toJson()),
  };

  final response = await http.post(url, body: jsonData, headers: {
    'authorization': _basicAuth, 
    'Accept': "application/json", 
    'Content-Type': 'application/x-www-form-urlencoded'
    },
    encoding: Encoding.getByName('utf-8')
  );

  if(response.statusCode == 204) { //note added successfully
    return 'success';
  } else {
    throw Exception('Failed to post absence');
  }
}