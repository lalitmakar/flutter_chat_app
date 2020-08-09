import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  getContacts() async {
    _contacts = await ContactsService.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RaisedButton(
      child: Text("Get Contacts "),
      onPressed: () {
        print(_contacts);
      },
    ));
  }
}
