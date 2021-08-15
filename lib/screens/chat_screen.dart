import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import '/data/controllers/chat_controller.dart';
import '/data/models/user.dart';
import '/data/models/message.dart';
import '/widgets/chat/message_bubble.dart';
//import '/widgets/chat/new_message.dart';
import '/core/styles/icon_broken.dart';
import '/core/utils/components.dart';

class ChatScreen extends StatelessWidget {
  
  final UserModel user;
  ChatScreen(this.user);
  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    var _msgController = TextEditingController();
    //Get.find<ChatController>().getMessages(receiverId: user.id!);
    //controller.getMessages(receiverId: user.id!);
    controller.peerUserId = user.id;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Row(
          children: [
            buildProfileImage(
              imageUrl: user.image!,
              isActive: user.isActive!,
              radius: 20.0,
              outerCircleSize: 12.0,
              innerCircleSize: 10.0,
              positionBottom: 2.0,
              positionRight: 1.0
            ),
            // buildCircleCachedImage(
            //   imageUrl: user.image!,
            //   radius: 20.0
            // ),
            const SizedBox(width: 10.0),
            Text(
              user.username!,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(IconBroken.Arrow___Left, size: 30),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).buttonColor,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(IconBroken.Video, size: 30),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(IconBroken.Call, size: 30),
          ),
        ],
      ),
      body: MixinBuilder<ChatController>(
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  //child: Messages(),
                  child: controller.messages.isEmpty
                    ? buildEmptyView(
                        text: 'Start Chating ..!',
                        icon: IconBroken.Chat,
                      )
                    : GroupedListView<MessageModel, String>(
                        physics: BouncingScrollPhysics(),
                        floatingHeader: true,
                        reverse: true,
                        sort: false,
                        elements: controller.messages,
                        groupBy: (message) {
                          return buildDateFormat(
                            date: message.messageDate!
                          );
                        },
                        groupSeparatorBuilder: (String msgDate) {
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              margin: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Get.theme.cardColor,
                              ),
                              child: Text(
                                buildDateConverter(
                                  messageDate: msgDate,
                                ),
                                style: Get.textTheme.headline3!.copyWith(
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, MessageModel message) {
                          return MessageBubble(
                            messageModel: message, 
                            isMe: controller.currentUser.id == message.senderId
                          );
                        },
                        //order: GroupedListOrder.DESC,
                        //useStickyGroupSeparators: true,
                      ),
                ),
                //NewMessage(/* chatController: controller */),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (!controller.isSendButtonVisible)
                      buildCircleButton(
                        icon: IconBroken.Image, 
                        onPressed: () {
                          controller.pickImage(/* senderId: uId */)
                          .then((imageUrl) {
                            if (imageUrl != null) {
                              controller.sendMessage(
                                //senderId: uId,
                                //receiverId: user.id!,
                                message: imageUrl,
                                //messageDate: DateTime.now().toString(),
                                isText: false,
                              );
                            }
                          });
                        },
                      ),
                    if (!controller.isSendButtonVisible)
                      const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 15.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(
                            color: Get.theme.hintColor,
                          ),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: TextField(
                                  controller: _msgController,
                                  autocorrect: true,
                                  enableSuggestions: true,
                                  textCapitalization: TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      controller.showSendButton();
                                    } else {
                                      controller.hideSendButton();
                                    }
                                  },
                                ),
                              ),
                            ),
                            if (controller.isSendButtonVisible)
                              buildCircleButton(
                                icon: IconBroken.Send, 
                                onPressed: () {
                                  if (_msgController.text.trim().isNotEmpty) {
                                    controller.sendMessage(
                                      //senderId: uId,
                                      //receiverId: user.id!,
                                      message: _msgController.text.trim(),
                                      //messageDate: DateTime.now().toString(),
                                      isText: true,
                                    );
                                    _msgController.clear();
                                    controller.hideSendButton();
                                  }
                                }
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // CircleButton for "SendButton" & "ImageButton"
  Widget buildCircleButton({
    required IconData icon,
    required Function() onPressed,
  }) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: Get.theme.accentColor,
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 1.0,
        child: Icon(
          icon,
          size: 25,
          color: Colors.white,
        ),
      ),
    );
  }

}