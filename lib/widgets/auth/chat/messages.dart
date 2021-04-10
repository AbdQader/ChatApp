import 'package:chat_app/widgets/auth/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("chat")
        .orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot) {
        // to show circular progress in waiting state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // to get the documents from the database
        final docs = snapshot.data.docs;
        final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemCount: docs.length,
          itemBuilder: (BuildContext context, int index) {
            return MessageBubble(
              docs[index]['text'], 
              docs[index]['username'],
              docs[index]['userImage'],
              docs[index]['userId'] == user.uid,
              key: ValueKey(docs[index].id),
            );
          },
        );
      },
    );
  }
}