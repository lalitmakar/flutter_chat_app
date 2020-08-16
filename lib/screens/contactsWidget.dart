import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage(this.contacts);
  final Iterable<Contact> contacts;
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contactListNew = List<Contact>();

  @override
  void initState() {
    super.initState();
    _convertToList();
  }

  _convertToList() {
    for (var person in widget.contacts) {
      _contactListNew.add(person);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
            itemCount: _contactListNew.length,
            itemBuilder: (BuildContext context, index) {
              return Card(
                child: ListTile(
                  leading: Text('${_contactListNew[index].avatar}'),
                  title: _contactListNew != null
                      ? Text("${_contactListNew[index].displayName}")
                      : Text(""),
                ),
              );
            }));
  }
}
