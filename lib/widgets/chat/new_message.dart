import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/data/controllers/chat_controller.dart';
import '/core/styles/icon_broken.dart';

class NewMessage extends StatelessWidget {
  
  //final ChatController chatController;
  //NewMessage({required this.chatController});
    
  @override
  Widget build(BuildContext context) {
    var _msgController = TextEditingController();
    return GetBuilder<ChatController>(
      builder: (chatController) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!chatController.isSendButtonVisible)
            buildCircleButton(
              icon: IconBroken.Image, 
              onPressed: () {
                chatController.pickImage()
                .then((imageUrl) {
                  if (imageUrl != null) {
                    chatController.sendMessage(
                      message: imageUrl,
                      isText: false,
                    );
                  }
                });
              },
            ),
          if (!chatController.isSendButtonVisible)
            const SizedBox(width: 10),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: Colors.grey[400]!,
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
                          if (value.trim().isNotEmpty) {
                            print('abd => 1 value changed: $value');
                            chatController.showSendButton();
                          } else {
                            print('abd => 2 value changed: $value');
                            chatController.hideSendButton();
                          }
                        },
                      ),
                    ),
                  ),
                  if (chatController.isSendButtonVisible)
                    buildCircleButton(
                      icon: IconBroken.Send, 
                      onPressed: () {
                        if (_msgController.text.trim().isNotEmpty) {
                          chatController.sendMessage(
                            message: _msgController.text.trim(),
                            isText: true,
                          );
                          _msgController.clear();
                          chatController.hideSendButton();
                        }
                      }
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CircleButton for "SendButton" & "ImageButton"
  Widget buildCircleButton({
    required IconData icon,
    required Function onPressed,
  }) {
    return CircleAvatar(
      radius: 30.0,
      backgroundColor: Colors.blue[300],
      child: MaterialButton(
        onPressed: () => onPressed(),
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