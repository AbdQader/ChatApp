import '/core/utils/constants.dart';

class MessageModel {
  
  // final String messageId;
  // final String senderId;
  // final String receiverId;
  // final String message;
  // final String messageDate;
  // final bool isText;

  // MessageModel({
  //   required this.messageId,
  //   required this.senderId,
  //   required this.receiverId,
  //   required this.message,
  //   required this.messageDate,
  //   required this.isText,
  // });

  // final String? messageId;
  // final String? senderId;
  // final String? receiverId;
  // final String? message;
  // final String? messageDate;
  final String? messageId, senderId, receiverId, messageDate;
  String? message;
  final bool? isText;
  bool? isRead/* , isReacted */;

  MessageModel({
    this.messageId,
    this.senderId,
    this.receiverId,
    this.message,
    this.messageDate,
    this.isText,
    this.isRead,
    //this.isReacted
  });
  
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json[MESSAGE_ID],
      senderId: json[SENDER_ID],
      receiverId: json[RECEIVER_ID],
      message: json[MESSAGE],
      messageDate: json[MESSAGE_DATE],
      isText: json[IS_TEXT],
      isRead: json[IS_READ],
      //isReacted: json[IS_REACTED]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      MESSAGE_ID: messageId,
      SENDER_ID: senderId,
      RECEIVER_ID: receiverId,
      MESSAGE: message,
      MESSAGE_DATE: messageDate,
      IS_TEXT: isText,
      IS_READ: isRead,
      //IS_REACTED: isReacted
    };
  }

}