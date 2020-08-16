import 'package:flutter/material.dart';

class CustomMessageWidget extends StatelessWidget {
  final String messageText;
  final String sender;
  final bool isMe;
  CustomMessageWidget({this.sender, this.messageText, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "$sender",
            style: TextStyle(color: Colors.black54),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0))
                    : BorderRadius.only(
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFF6487FD),
                  Color(0xFF41D2E7),
                ])),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text(
                '$messageText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
