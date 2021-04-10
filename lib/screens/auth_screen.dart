import 'dart:io';
import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // this fun to SignIn/SignUp and store the user info in the database
  void _submitAuthForm(String username, String email, String password, File image, bool isLogin, BuildContext ctx) async {
    
    // for authentication response
    UserCredential authResult;

    try {
      
      // to show the CircularProgressIndicator
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        // to sign user in with email and password
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
        );
      } else {
        // to sign user up with email and password
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        
        // to defined the image path
        final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(authResult.user.uid + '.jpg');

        // to upload the image
        await ref.putFile(image);
        // to get the image url
        final url = await ref.getDownloadURL();

        // add the new user to firestore database
        await FirebaseFirestore.instance.collection("users")
          .doc(authResult.user.uid).set({
            'username': username, 
            'email': email, 
            'password': password,
            'image_url': url,
          });
      }
      
    } on FirebaseAuthException catch (e) {
      String message = 'Error Occurred';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        //backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}