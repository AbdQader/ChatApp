import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/controllers/user_controller.dart';
import '/data/models/user.dart';
import '/core/utils/components.dart';
import '/core/utils/constants.dart';

class AuthController extends GetxController {

  // For Firebase Auth & Firestore & Storage
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage  = FirebaseStorage.instance;
  
  // For Firebase User
  // late Rx<User> _user;
  // User get user => _user.value;

  // For Current User Id
  // Rx<String> _uId = ''.obs;
  // String get uId => _uId.value;

  // For image picker
  File? _pickedImage;
  File? get getPickedImage => _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // For auth state
  bool _isLogin = true;
  bool get isLogin => _isLogin;

  // For loading state
  Rx<bool> _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  // For password visibility
  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;

  // @override
  // void onInit() {
  //   super.onInit();
  //   _user.bindStream(_auth.authStateChanges());
  // }
  
  // For submit auth form
  Future<void> submitAuthForm({
    required String username, 
    required String email, 
    required String password
  }) async {
    // For authentication response
    UserCredential authResult;
    try {
      _isLoading.value = true;

      if (isLogin) {
        // To sign user in with email and password
        authResult = await _login(email, password);
        Get.put(UserController()).updateUserStatus(isActive: true);
        _isLoading.value = false;
      } else {
        // To sign user up with email and password
        authResult = await _register(email, password);

        // Defined the image path
        final ref = _storage.ref()
          .child('${authResult.user!.uid}/$USER_IMAGE/profile_image.jpg');
          // .child(USER_IMAGE)
          // .child(authResult.user!.uid + '.jpg');

        await ref.putFile(getPickedImage!); // Upload the image
        final url = await ref.getDownloadURL(); // Get the image url

        // Create UserModel Object
        UserModel user = UserModel(
          id: authResult.user!.uid,
          username: username,
          email: email,
          password: password,
          image: url,
          isActive: true,
        );
        
        // Add the user to firestore
        _addUserToFirestore(user);
        _isLoading.value = false;
      }
    }
    catch (error) {
      _isLoading.value = false;
      String message = buildErrorMessage(error.toString());
      showSnackbar('Error Occurred', message);
    }
    update();
  }

  // To add the new user to firestore database
  Future<void> _addUserToFirestore(UserModel user) async {
    try {
      await _firestore
        .collection(USERS)
        .doc(user.id)
        .set(user.toJson());
    } catch (error) {
      throw error;
    }
  }

  // To login the user
  Future<UserCredential> _login(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // To register the user
  Future<UserCredential> _register(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  // To logout the user
  // Future<void> logout() async {
  //   try {
  //     Get.find<UserController>().clear();
  //     await _auth.signOut();
  //   } catch (error) {
  //     showSnackbar('Error Occured', error.toString());
  //   }
  // }

  // To get the image that user select it
  Future<void> pickImage(ImageSource src) async {
    final pickedImageFile = await _picker.getImage(source: src, imageQuality: 50, maxWidth: 150);
    if (pickedImageFile != null) {
      _pickedImage = File(pickedImageFile.path);
      update();
    }
  }

  // To change between auth state "login" & "register"
  void changeAuthState() {
    _isLogin = !_isLogin;
    update();
  }

  // This function to change the password visibility
  void changePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    update();
  }
  
}