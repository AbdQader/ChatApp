import 'dart:io';

import 'package:chat_app/widgets/auth/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {

  final void Function(String username, String email, String password, File image, bool isLogin, BuildContext ctx) submitFun;
  final bool isLoading;

  AuthForm(this.submitFun, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _username = '';
  String _email = '';
  String _password = '';
  File _userImageFile;

  void _pickImage(File pickedImage) {
    _userImageFile = pickedImage;
  }

  // to send the user info to "_submitAuthForm" function in "auth_screen"
  void _submit() {
    final isValid = _formKey.currentState.validate();
    // to close the keyboard after the user click on the button
    FocusScope.of(context).unfocus();

    if (!_isLogin && _userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please pick an image'),
      ));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFun(_username.trim(), _email.trim(), _password.trim(), _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) 
                  UserImagePicker(_pickImage),
                if (!_isLogin)
                  TextFormField(
                    autocorrect: true,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.words,
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    onSaved: (newValue) => _username = newValue,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _email = newValue,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email Address'),
                ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 characters';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _password = newValue,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 12),
                if (widget.isLoading)
                  CircularProgressIndicator(),
                if(!widget.isLoading)
                  ElevatedButton(
                  child: Text(_isLogin ? 'Login' : 'Sign Up'),
                  onPressed: _submit,
                ),
                if(!widget.isLoading)
                  TextButton(
                  child: Text(_isLogin
                    ? 'Create new account'
                    : 'Already have an account'
                  ),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}