import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/controllers/user_controller.dart';
import '/data/models/user.dart';
import '/data/models/message.dart';
import '/core/utils/components.dart';
import '/core/utils/constants.dart';

class ChatController extends GetxController {

  // For Firebase Firestore & Storage
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  // For fetched messages
  // List<MessageModel> _messages = <MessageModel>[];
  // List<MessageModel> get messages => _messages;
  
  Rx<List<MessageModel>> _messages = Rx<List<MessageModel>>([]);
  List<MessageModel> get messages => _messages.value;

  // For image picker
  File? _pickedImage;
  File? get getPickedImage => _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // For send message button
  bool _isSendButtonVisible = false;
  bool get isSendButtonVisible => _isSendButtonVisible;

  UserModel currentUser = Get.find<UserController>().user;
  String? peerUserId;

  @override
  void onReady() {
    super.onReady();
    print('abd => onReady called');
    if (peerUserId != null)
    {
      //getMessages();
      _messages.bindStream(getMyMessages());
      print('abd => the chat stream is binded');
    }
  }

  @override
  void onClose() {
    _messages.close();
    super.onClose();
  }

  // This function to get the chat messages
  Stream<List<MessageModel>> getMyMessages() {
    return _firestore
      .collection(USERS)
      .doc(currentUser.id)
      .collection(CHATS)
      .doc(peerUserId)
      .collection(MESSAGES)
      .orderBy(MESSAGE_DATE, descending: true)
      .snapshots()
      .map((querySnapshot) {
        List<MessageModel> mMessages = [];
        querySnapshot.docs.forEach((document) {
          var message = MessageModel.fromJson(document.data());
          if (message.senderId == peerUserId) {
            updateMessageStatus(
              receiverId: peerUserId!,
              messageId: message.messageId!,
              isRead: true
            );
          }
          mMessages.add(message);
        });
        return mMessages;
      });
  }

  // This function to get the chat messages
  void getMessages(/* {required String receiverId} */) {
    _firestore
      .collection(USERS)
      .doc(currentUser.id)
      .collection(CHATS)
      .doc(peerUserId)
      .collection(MESSAGES)
      .orderBy(MESSAGE_DATE, descending: true)
      .snapshots()
      .listen((querySnapshot) {
        _messages.value.clear();
        querySnapshot.docs.forEach((document) {
          //_messages.add(MessageModel.fromJson(document.data()));
          var message = MessageModel.fromJson(document.data());
          if (message.senderId == peerUserId) {
            updateMessageStatus(
              receiverId: peerUserId!,
              messageId: message.messageId!,
              isRead: true
            );
          }
          _messages.value.add(message);
        });
        update();
      });
  }

  // This function to send the message
  void sendMessage({
    //required String receiverId,
    required String message,
    //required String messageDate,
    required bool isText,
  }) {

    String msgId = _firestore.collection(USERS).doc().id;
    
    MessageModel messageModel = MessageModel(
      messageId: msgId,
      senderId: currentUser.id,
      receiverId: peerUserId,
      message: message,
      messageDate: DateTime.now().toString(), //FieldValue.serverTimestamp().toString(),
      isText: isText,
      isRead: false,
    );

    _firestore
      .collection(USERS)
      .doc(currentUser.id)
      .collection(CHATS)
      .doc(peerUserId)
      .collection(MESSAGES)
      .doc(msgId)
      .set(messageModel.toJson())
      .then((value) {
        print('abd => sender: then: done');
      })
      .catchError((error) {
        showSnackbar('Error Occurred', 'can\'t send the message!');
        print('abd => sender: sendMessage: catchError: $error');
      });

    _firestore
      .collection(USERS)
      .doc(peerUserId)
      .collection(CHATS)
      .doc(currentUser.id)
      .collection(MESSAGES)
      .doc(msgId)
      .set(messageModel.toJson())
      .then((value) {
        print('abd => receiver: then: done');
      })
      .catchError((error) {
        print('abd => receiver: sendMessage: catchError: $error');
      });

    // Create object from "MessageModel"
    // MessageModel messageModel = MessageModel(
    //   senderId: currentUser.id,
    //   receiverId: receiverId,
    //   message: message,
    //   messageDate: messageDate,
    //   isText: isText,
    // );

    // Add the message for the "Sender"
    // _firestore
    //   .collection(USERS)
    //   .doc(currentUser.id)
    //   .collection(CHATS)
    //   .doc(receiverId)
    //   .collection(MESSAGES)
    //   .add(messageModel.toJson())
    //   .then((value) {
    //     print('abd => sender: then: $value');
    //   })
    //   .catchError((error) {
    //     print('abd => sender: sendMessage: catchError: $error');
    //   });

    // Add the message for the "Receiver"
    // _firestore
    //   .collection(USERS)
    //   .doc(receiverId)
    //   .collection(CHATS)
    //   .doc(currentUser.id)
    //   .collection(MESSAGES)
    //   .add(messageModel.toJson())
    //   .then((value) {
    //     print('abd => receiver: then: $value');
    //   })
    //   .catchError((error) {
    //     print('abd => receiver: sendMessage: catchError: $error');
    //   });

  }

  // To upload the image message to firebase storage
  Future<String> uploadImage({required File image}) async {
    var key = DateTime.now().millisecondsSinceEpoch.toString();
    // Defined the image path
    final ref = _storage.ref()
      .child('${currentUser.id}/$CHAT_IMAGE')
      .child('${currentUser.id}-$key.jpg');
    // .child(CHAT_IMAGE)
    // .child();

    // Upload the image
    await ref.putFile(image);
    // Get the image url
    final url = await ref.getDownloadURL();
    return url;
  }

  // To get the image that user select it
  Future<String?> pickImage() async {
    String? imageUrl;
    final pickedImageFile = await _picker.getImage(
      source: ImageSource.gallery, 
      imageQuality: 50, 
      maxWidth: 150
    );
    if (pickedImageFile != null) {
      imageUrl = await uploadImage(
        image: File(pickedImageFile.path)
      );
    }
    return imageUrl;
  }

  // This function to delete the message
  void deleteMessage({
    required String receiverId,
    required String messageId,
    required bool isUnsend
  }) {
    
    // Delete the message for me
    _firestore
      .collection(USERS)
      .doc(currentUser.id)
      .collection(CHATS)
      .doc(receiverId)
      .collection(MESSAGES)
      .doc(messageId)
      .delete()
      .then((_) {
        print('abd => receiver: deleteMessage: then: deleted');
      })
      .catchError((error) {
        print('abd => sender: deleteMessage: catchError: $error');
      });
    // Unsend the message
    if (isUnsend) {
      _firestore
      .collection(USERS)
      .doc(receiverId)
      .collection(CHATS)
      .doc(currentUser.id)
      .collection(MESSAGES)
      .doc(messageId)
      .delete()
      .then((_) {
        print('abd => receiver: deleteMessage: then: deleted');
      })
      .catchError((error) {
        print('abd => receiver: deleteMessage: catchError: $error');
      });
    }
  }

  void updateMessageStatus({
    required String receiverId,
    required String messageId,
    required bool isRead
  }) {
    // Update the message for the "Sender"
    _firestore
      .collection(USERS)
      .doc(currentUser.id)
      .collection(CHATS)
      .doc(receiverId)
      .collection(MESSAGES)
      .doc(messageId)
      .update({
        IS_READ: isRead
      })
      .then((value) {
        //print('abd => Sender: Message Updated Successfully');
      })
      .catchError((error) {
        print('abd => Sender: updateMessage: catchError: $error');
      });

    // Update the message for the "Receiver"
    _firestore
      .collection(USERS)
      .doc(receiverId)
      .collection(CHATS)
      .doc(currentUser.id)
      .collection(MESSAGES)
      .doc(messageId)
      .update({
        IS_READ: isRead
      })
      .then((value) {
        //print('abd => Receiver: Message Updated Successfully');
      })
      .catchError((error) {
        print('abd => Receiver: updateMessage: catchError: $error');
      });
  }

  // This function to show the send button
  void showSendButton() {
    _isSendButtonVisible = true;
    update();
  }

  // This function to hide the send button
  void hideSendButton() {
    _isSendButtonVisible = false;
    update();
  }

}