import '/data/models/message.dart';
import '/core/utils/constants.dart';

class UserModel {

  // final String? id;
  // final String? username;
  // final String? email;
  // final String? password;
  // final String? image;
  // String? lastMessage;
  // String? lastMessageDate;
  String? id, username, email, password, image;
  bool? isActive;
  //String? lastMessage, lastMessageDate;
  //bool? isLastMessageRead;
  MessageModel? lastMessage;

  UserModel({
    this.id,
    this.username, 
    this.email, 
    this.password, 
    this.image,
    this.isActive,
    this.lastMessage,
    // this.lastMessageDate,
    // this.isLastMessageRead,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[ID],
    username: json[USERNAME],
    email: json[EMAIL],
    password: json[PASSWORD],
    image: json[IMAGE],
    isActive: json[IS_ACTIVE],
  );

  Map<String, dynamic> toJson() => {
    ID: id,
    USERNAME: username,
    EMAIL: email,
    PASSWORD: password,
    IMAGE: image,
    IS_ACTIVE: isActive,
  };

}