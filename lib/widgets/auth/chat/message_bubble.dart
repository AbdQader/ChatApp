import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final Key key;
  final String message;
  final String username;
  final String userImage;
  final bool isMe;

  MessageBubble(this.message, this.username, this.userImage, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: !isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMe)
          Container(
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.only(top: 20),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
          ),
        Container(
          constraints: BoxConstraints(maxWidth: 150),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: !isMe ? Colors.grey[300] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
              bottomLeft: isMe ? Radius.circular(0) : Radius.circular(14),
              bottomRight: !isMe ? Radius.circular(0) : Radius.circular(14)
            ),
          ),
          child: Column(
            crossAxisAlignment: !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: !isMe 
                  ? Colors.black 
                  : Theme.of(context).accentTextTheme.headline6.color,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  color: !isMe 
                  ? Colors.black 
                  : Theme.of(context).accentTextTheme.headline6.color,
                ),
                textAlign: !isMe ? TextAlign.end : TextAlign.start,
              ),
            ],
          ),
        ),
        if (!isMe)
          Container(
            margin: EdgeInsets.only(left: 8),
            padding: EdgeInsets.only(top: 20),
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImage),
            ),
          ),
      ],
    );
  }
}