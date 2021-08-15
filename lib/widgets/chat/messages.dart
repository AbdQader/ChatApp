import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/data/controllers/chat_controller.dart';
//import '/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<ChatController>(
      builder: (controller) => ListView.builder(
        reverse: true,
        itemCount: controller.messages.length,
        itemBuilder: (BuildContext context, int index) {
          return Text('the messages');
          //return MessageBubble(controller.messages[index]);
        },
      ),
    );

    // return StreamBuilder(
    //   stream: FirebaseFirestore.instance.collection("chat")
    //     .orderBy('time', descending: true).snapshots(),
    //   builder: (context, snapshot) {
    //     // to show circular progress in waiting state
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return CircularProgressIndicator();
    //     }
    //     // to get the documents from the database
    //     //final docs = snapshot.data.docs;
    //     final docs = snapshot.data as Map<String, dynamic>;
    //     final user = FirebaseAuth.instance.currentUser;
    //     return ListView.builder(
    //       reverse: true,
    //       itemCount: docs.length,
    //       itemBuilder: (BuildContext context, int index) {
    //         return MessageBubble(
    //           docs[index]['text'], 
    //           docs[index]['username'],
    //           docs[index]['userImage'],
    //           docs[index]['userId'] == user!.uid,
    //           key: ValueKey(docs[index].id),
    //         );
    //       },
    //     );
    //   },
    // );
  }
}