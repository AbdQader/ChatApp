import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bubble/bubble.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/data/controllers/chat_controller.dart';
import '/data/models/message.dart';
import '/core/utils/components.dart';

class MessageBubble extends StatelessWidget {

  final MessageModel messageModel;
  final bool isMe;
  const MessageBubble({required this.messageModel, required this.isMe});

  @override
  Widget build(BuildContext context) {
    if (isMe)
      return InkWell(
        onLongPress: () => buildBottomSheet(),
        child: buildMyMessage(),
      );
    else
      return InkWell(
        onLongPress: () => buildBottomSheet(),
        child: buildPeerMessage(),
      );
  }

  // For My Messages "Sender Messages"
  Widget buildMyMessage() {
    if (!messageModel.isText!)
      return buildMyImageMessage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                color: Get.theme.accentColor,//Colors.blue[300],
                elevation: 0,
                padding: const BubbleEdges.all(10.0),
                nip: BubbleNip.rightTop,
                child: Text(
                  messageModel.message!,
                  style: Get.textTheme.headline3!.copyWith(
                    color: Colors.white,
                  ),
                ),
                // child: buildText(
                //   text: messageModel.message!,
                //   size: 16.0,
                //   color: Colors.white,
                // ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buildTimeFormat(date: messageModel.messageDate!),
                  style: Get.textTheme.headline3!.copyWith(
                    fontSize: 12.0,
                  ),
                ),
                // buildText(
                //   text: buildTimeFormat(date: messageModel.messageDate!),
                //   size: 12.0,
                //   color: Get.theme.buttonColor,
                // ),
                const SizedBox(width: 5),
                Icon(
                  Icons.done_all,
                  color: messageModel.isRead!
                    ? Get.theme.accentColor
                    : Colors.grey[400],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // For Peer Messages "Receiver Messages"
  Widget buildPeerMessage() {
    if (!messageModel.isText!)
      return buildPeerImageMessage();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Bubble(
                color: Get.theme.cardColor,
                elevation: 0,
                padding: const BubbleEdges.all(10.0),
                nip: BubbleNip.leftTop,
                child: Text(
                  messageModel.message!,
                  style: Get.textTheme.headline3,
                ),
                // child: buildText(
                //   text: messageModel.message!,
                //   size: 16.0,
                //   color: Get.theme.buttonColor,
                // ),
              ),
            ),
            Text(
              buildTimeFormat(date: messageModel.messageDate!),
              style: Get.textTheme.headline3!.copyWith(
                fontSize: 12.0,
              ),
            ),
            // buildText(
            //   text: buildTimeFormat(date: messageModel.messageDate!),
            //   size: 12.0,
            //   color: Colors.black87,
            // ),
          ],
        ),
      ],
    );
  }

  // For My Messages "Sender Messages"
  // Widget buildMyMessage() {
  //   if (!messageModel.isText!)
  //     return buildMyImageMessage();
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Container(
  //             constraints: const BoxConstraints(maxWidth: 200),
  //             margin: EdgeInsets.symmetric(vertical: 5),
  //             child: Bubble(
  //               color: Colors.blue[300],
  //               elevation: 0,
  //               padding: const BubbleEdges.all(10.0),
  //               nip: BubbleNip.rightTop,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   buildText(
  //                     text: messageModel.message!,
  //                     size: 16.0,
  //                     color: Colors.white,
  //                   ),
  //                   const SizedBox(height: 5),
  //                   Row(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       buildText(
  //                         text: buildTimeFormat(date: messageModel.messageDate!),
  //                         size: 12.0,
  //                         color: Colors.grey[100],
  //                       ),
  //                       const SizedBox(width: 5),
  //                       Icon(
  //                         Icons.done_all,
  //                         color: messageModel.isRead!
  //                           ? Colors.blue
  //                           : Colors.grey[200],
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // For Peer Messages "Receiver Messages"
  // Widget buildPeerMessage() {
  //   if (!messageModel.isText!)
  //     return buildPeerImageMessage();
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: [
  //           Container(
  //             constraints: const BoxConstraints(maxWidth: 200),
  //             margin: EdgeInsets.symmetric(vertical: 5),
  //             child: Bubble(
  //               color: Colors.grey[300],
  //               elevation: 0,
  //               padding: const BubbleEdges.all(10.0),
  //               nip: BubbleNip.leftTop,
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   buildText(
  //                     text: messageModel.message!,
  //                     size: 16.0,
  //                     color: Colors.black,
  //                   ),
  //                   const SizedBox(height: 5),
  //                   buildText(
  //                     text: buildTimeFormat(date: messageModel.messageDate!),
  //                     size: 12.0,
  //                     color: Colors.black87,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // For My Image Messages
  Widget buildMyImageMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Bubble(
                color: Get.theme.accentColor,//Colors.blue[300],
                  elevation: 0,
                  padding: const BubbleEdges.all(4.0),
                  nip: BubbleNip.rightTop,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CachedNetworkImage(
                        imageUrl: messageModel.message!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            width: 130.0,
                            height: 130.0,
                            child: showCircularProgress(),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: buildText(
                          text: buildTimeFormat(
                            date: messageModel.messageDate!
                          ),
                          size: 12.0,
                          color: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // For Peer Image Messages
  Widget buildPeerImageMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: Bubble(
                color: Get.theme.accentColor,//Colors.blue[300],
                  elevation: 0,
                  padding: const BubbleEdges.all(4.0),
                  nip: BubbleNip.leftTop,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CachedNetworkImage(
                        imageUrl: messageModel.message!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) {
                          return Container(
                            width: 130.0,
                            height: 130.0,
                            child: showCircularProgress(),
                          );
                        },
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        child: buildText(
                          text: buildTimeFormat(
                            date: messageModel.messageDate!
                          ),
                          size: 12.0,
                          color: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // For Delete Message
  void buildBottomSheet() {
    Get.bottomSheet(
      GetBuilder<ChatController>(
        builder: (controller) => Container(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              if (isMe)
                Text(
                  'Who do you want to remove this message for?',
                  style: Get.theme.textTheme.headline3,
                ),
                // buildText(
                //   text: 'Who do you want to remove this message for?',
                //   size: 16.0,
                //   color: Colors.black,
                // ),
              if (isMe)
                buildListTile(
                  title: 'Unsend message',
                  onTap: () {
                    controller.deleteMessage(
                      receiverId: messageModel.receiverId!,
                      messageId: messageModel.messageId!,
                      isUnsend: true,
                    );
                    Get.back();
                  }
                ),
              buildListTile(
                title: 'Remove for you',
                onTap: () {
                  controller.deleteMessage(
                    receiverId: isMe
                      ? messageModel.receiverId!
                      : messageModel.senderId!,
                    messageId: messageModel.messageId!,
                    isUnsend: false,
                  );
                  Get.back();
                }
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Get.theme.primaryColor,
    );
  }

  // For ListTile
  Widget buildListTile({
    required String title,
    required Function() onTap
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(0.0),
      dense: true,
      title: Text(
        title,
        style: Get.theme.textTheme.headline2,
      ),
      // title: buildText(
      //   text: title,
      //   size: 18.0,
      //   color: Colors.black,
      //   weight: FontWeight.bold,
      // ),
      trailing: Icon(
        Icons.delete,
        size: 25,
        color: Colors.red,
      ),
    );
  }

}