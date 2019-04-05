import 'package:fyp/models/contact.dart';

List<Contact> createContactList(List data) {
  List<Contact> list = new List();
  for (int i = 0; i < data.length; i++) {
    String title = data[i]['properties'][1]['value'];
    int id = data[i]['id'];

    Contact contact = new Contact(name: title, id: id);
    list.add(contact);
  }

  return list;
}