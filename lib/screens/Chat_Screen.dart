import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterchatapplication/ReusableComponents/customMessageWidgetsLogic.dart';
import 'package:flutterchatapplication/screens/cameraScreen.dart';
import 'package:flutterchatapplication/screens/contactsWidget.dart';
import 'package:flutterchatapplication/constants.dart';
import 'package:permission_handler/permission_handler.dart';

FirebaseUser loggedInUser;
final _firestore = Firestore.instance;

class ChatScreen extends StatefulWidget {
  static final String id = "Chat_Screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Iterable<Contact> contactsList;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getContacts();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  getContacts() async {
    var status = await Permission.contacts.status;
    do {
      if (!status.isGranted)
        await Permission.contacts.request();
      else
        status = PermissionStatus.granted;
    } while (!status.isGranted);
    if (status == PermissionStatus.granted) {
      final _contactsinternal = await ContactsService.getContacts();
      setState(() {
        contactsList = _contactsinternal;
      });
    }
  }

//  to fetch the data from the firebase firestore
//  void getmessages() async {
//    var doc = await _firestore.collection("messages").getDocuments();
//    var n = doc.documents;
//    for (var d in n) {
//      print(d.data["message"]);
//    }
//  }
//

//  to fetch the stream of incoming messages (snapshots) from firebase firestore
//  void getstreammessages() async {
//    await for (var snapshot in _firestore.collection("messages").snapshots()) {
//      for (var doc in snapshot.documents) {
//        print(doc.data);
//      }
//    }
//  }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = new TextEditingController();
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
                tooltip: "LogOut",
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);
                }),
          ],
          title: Text('⚡️ Group Chat'),
          centerTitle: true,
          backgroundColor: Colors.lightBlueAccent,
          bottom: TabBar(tabs: [
            Tab(
              icon: Icon(Icons.photo_camera),
            ),
            Tab(
              child: Text("Chats"),
              icon: Icon(Icons.message),
            ),
            Tab(
              child: Text("Contacts"),
              icon: Icon(Icons.contact_mail),
            ),
          ]),
        ),
        body: SafeArea(
          child: TabBarView(
            children: <Widget>[
              CameraWidgetLogic(),
              ChatsTab(
                textController: textController,
              ),
              ContactsPage(contactsList),
            ],
          ),
        ),
      ),
    );
  }
}

class StreamLogic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var docs = snapshot.data.documents.reversed;
            List<CustomMessageWidget> messageWidgets = [];
            for (var doc in docs) {
              var messageText = doc['message'];
              var sender = doc['sender'];
              String currentLoggedInUser = loggedInUser.email;
              var messageWidget = CustomMessageWidget(
                sender: sender,
                messageText: messageText,
                isMe: currentLoggedInUser == sender,
              );
              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                children: messageWidgets,
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ChatsTab extends StatefulWidget {
  ChatsTab({this.textController});
  TextEditingController textController = new TextEditingController();
  @override
  _ChatsTabState createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamLogic(),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: widget.textController,
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                Container(
                  child: FloatingActionButton(
                    elevation: 10.0,
                    tooltip: "Send",
                    shape: StadiumBorder(),
                    child: Icon(Icons.send),
                    onPressed: () {
                      //Implement send functionality.
                      if (widget.textController.text.isNotEmpty) {
                        _firestore.collection('messages').add({
                          'message': widget.textController.text,
                          'sender': loggedInUser.email,
                          'time': DateTime.now().toString()
                        });
                        widget.textController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
