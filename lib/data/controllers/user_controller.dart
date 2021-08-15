import 'dart:io';
import 'package:chat_app/core/utils/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/models/user.dart';
import '/data/models/message.dart';
import '/core/utils/constants.dart';

class UserController extends GetxController {
  
  // For Firebase Firestore & Storage
  final _firestore = FirebaseFirestore.instance;
  final _storage  = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  // For UserModel
  Rx<UserModel> _userModel = UserModel().obs;
  UserModel get user => _userModel.value;

  // For users coming from firestore
  Rx<List<UserModel>> _users = Rx<List<UserModel>>([]);
  List<UserModel> get users => _users.value;

  // For loading state
  Rx<bool> _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // For password visibility
  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;

  // To get the current user
  final _currentUser = FirebaseAuth.instance.currentUser!;

  // to sort the users array by last message date
  /* users.sort((user1, user2) {
    print('abd => UC: inside if statement');
    if (user1.lastMessage != null && user2.lastMessage != null)
    {
      print('abd => UC: msg date: ${user1.lastMessage!.messageDate!}');
      return user1.lastMessage!.messageDate!.compareTo(user2.lastMessage!.messageDate!);
    } else {
      return 0;
    }
  }); */

  @override
  void onInit() {
    super.onInit();
    getUsers(); // Call "getUsers" function
    //_users.bindStream(getAllUsers());
    getCurrentUser(); // Call "getCurrentUser" function
    //updateUserStatus(isActive: true);
  }

  // Stream<List<UserModel>> getAllUsers() {
  //   _isLoading.value = true;
  //   return _firestore
  //     .collection(USERS)
  //     .snapshots()
  //     .map((querySnapshot) {
  //       List<UserModel> usersList = [];
  //       querySnapshot.docs.forEach((document) async {
  //         if (_currentUser.uid != document.data()[ID]) {
  //           MessageModel? lastMsg;
  //           await getLastMessage(
  //             receiverId: document.data()[ID], 
  //             onComplete: (lastMessage) {
  //               lastMsg = lastMessage;
  //             }
  //           );
  //           var userModel = UserModel.fromJson(document.data());
  //           userModel.lastMessage = lastMsg;
  //           usersList.add(userModel);
  //         }
  //       });
  //       _isLoading.value = false;
  //       return usersList;
  //     });
  // }

  // This function to get the users from firestore
  void getUsers() {
    _isLoading.value = true;
    _firestore.collection(USERS).snapshots()
      .listen((querySnapshot) {
        _users.value.clear();
        querySnapshot.docs.forEach((document) async {
          if (_currentUser.uid != document.data()[ID]) {
            var lastMsg = MessageModel();
            await getLastMessage(
              receiverId: document.data()[ID], 
              onComplete: (lastMessage) {
                lastMsg = lastMessage;
              }
            );
            var userModel = UserModel.fromJson(document.data());
            userModel.lastMessage = lastMsg;
            _users.value.insert(0, userModel);
          }
        });
      });
    _isLoading.value = false;
  }
  
  // This function to get the current user from firestore
  void getCurrentUser() {
    _firestore.collection(USERS).doc(_currentUser.uid).get()
      .then((document) {
        _userModel.value = UserModel.fromJson(document.data()!);
        //update();
      })
      .catchError((error) {
        print('abd => getCurrentUser: catchError: $error');
      });
  }

  // This function to update the user status "is active or not"
  void updateUserStatus({required bool isActive}) {
    _firestore.collection(USERS).doc(_currentUser.uid)
      .update({
        IS_ACTIVE: isActive,
      })
      .catchError((error) {
        print('abd => updateUserStatus: catchError: $error');
      });
  }

  // This function to update the user profile picture
  Future<void> updateUserImage({required ImageSource src}) async {
    // Get the image that user select it
    final pickedImageFile = await ImagePicker().getImage(
      source: src,
      imageQuality: 50,
      maxWidth: 150
    );
    if (pickedImageFile != null)
    {
      var pickedImage = File(pickedImageFile.path);
      
      // Upload the user image to storage
      final ref = _storage.ref()
        .child('${_currentUser.uid}/$USER_IMAGE/profile_image.jpg');

      await ref.putFile(pickedImage); // Upload the image
      final url = await ref.getDownloadURL(); // Get the image url
      
      // Update the user image in firestore
      _firestore
        .collection(USERS)
        .doc(_currentUser.uid)
        .update({IMAGE: url})
        .then((_) {
          _userModel.value.image = url;
          showSnackbar(
            'Task Completed',
            'Picture updated successfully'
          );
        })
        .catchError((error) {
          showSnackbar(
            'Error Occurred',
            '$error'
          );
        });
    }
  }

  // update username
  void updateUsername({
    required String newUsername,
    required String password,
  }) {
    if (user.password != password)
      return;

    _firestore
      .collection(USERS)
      .doc(_currentUser.uid)
      .update({USERNAME: newUsername})
      .then((_) {
        _userModel.value.username = newUsername;
        showSnackbar(
          'Task Completed',
          'Username updated successfully'
        );
        update();
      })
      .catchError((error) {
        showSnackbar(
          'Error Occurred',
          '$error'
        );
      });
  }

  // update user email
  void updateUserEmail({
    required String newEmail,
    required String password,
  }) {
    if (user.password != password)
      return;

    _auth.signInWithEmailAndPassword(
      email: user.email!,
      password: user.password!
    ).then((_) {
      _currentUser.updateEmail(newEmail)
      .then((_) {
        _firestore
          .collection(USERS)
          .doc(_currentUser.uid)
          .update({EMAIL: newEmail})
          .then((_) {
            _userModel.value.email = newEmail;
            showSnackbar(
              'Task Completed',
              'Email updated successfully'
            );
            update();
          })
          .catchError((error) {
            print('abd => firestore error: $error');
            showSnackbar('Error Occurred', '$error');
          });
      })
      .catchError((error) {
        print('abd => auth error: $error');
        showSnackbar('Error Occurred', '$error');
      });
    })
    .catchError((error) {
      print('abd => login error: $error');
      showSnackbar('Error Occurred', '$error');
    });
  }

  // update user password
  void updateUserPassword({
    required String newPassword,
    required String password,
  }) {
    if (user.password != password)
      return;

    _auth.signInWithEmailAndPassword(
      email: user.email!,
      password: user.password!
    ).then((_) {
      _currentUser.updatePassword(newPassword)
      .then((_) {
        _firestore
        .collection(USERS)
        .doc(_currentUser.uid)
        .update({PASSWORD: newPassword})
        .then((_) {
          _userModel.value.password = newPassword;
          showSnackbar(
            'Task Completed',
            'Password updated successfully'
          );
        })
        .catchError((error) {
          print('abd => firestore error: $error');
          showSnackbar('Error Occurred', '$error');
        });
      })
      .catchError((error) {
        print('abd => auth error: $error');
        showSnackbar('Error Occurred', '$error');
      });
    })
    .catchError((error) {
      print('abd => login error: $error');
      showSnackbar('Error Occurred', '$error');
    });
  }

  // This function to get the last message between users
  Future<void> getLastMessage({
    required String receiverId,
    required onComplete(MessageModel lastMessage)
  }) async {
    await _firestore
    .collection(USERS)
    .doc(_currentUser.uid)
    .collection(CHATS)
    .doc(receiverId)
    .collection(MESSAGES)
    .orderBy(MESSAGE_DATE, descending: true)
    .limit(1)
    .get()
    .then((querySnapshot) {
      if (querySnapshot.docs.length > 0) {
        var messageModel = MessageModel.fromJson(querySnapshot.docs.last.data());
        var sender = _currentUser.uid == messageModel.senderId ? 'You: ' : '';
        var msgText = !messageModel.isText! ? 'sent an image' : messageModel.message;
        messageModel.message = '$sender$msgText';
        onComplete(messageModel);
        update();
      }
    })
    .catchError((error) {
      print('abd => getLastMessage: catchError: $error');
    });
  }

  // This function to change the password visibility
  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }

  // This function to clear the user from userController
  // void clear() {
  //   _userModel.value = UserModel();
  //   updateUserStatus(isActive: false);
  //   //update();
  // }

  // To logout the user
  void logout() async {
    try {
      updateUserStatus(isActive: false);
      _userModel.value = UserModel();
      await _auth.signOut();
    } catch (error) {
      showSnackbar('Error Occured', error.toString());
    }
  }

}