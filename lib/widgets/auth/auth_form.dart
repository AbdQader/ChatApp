import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/data/controllers/auth_controller.dart';
import '/widgets/pickers/user_image_picker.dart';
import '/core/utils/components.dart';

class AuthForm extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  // to submit the user info
  void _submit() {
    //var controller = Get.find<AuthController>();
    var controller = Get.put(AuthController());
    
    // to close the keyboard after the user click on the button
    Get.focusScope!.unfocus(); //FocusScope.of(context).unfocus();

    // Check image picked
    if (!controller.isLogin && controller.getPickedImage == null) {
      showSnackbar('Image Missing', 'Please pick an image');
      return;
    }

    // Check form validation
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.submitAuthForm(
        username: _username.text, 
        email: _email.text, 
        password: _password.text
      );
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
            child: MixinBuilder<AuthController>(
              init: AuthController(),
              builder: (controller) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!controller.isLogin)
                    UserImagePicker(),
                  if (!controller.isLogin)
                    TextFormField(
                      controller: _username,
                      autocorrect: true,
                      enableSuggestions: false,
                      textCapitalization: TextCapitalization.words,
                      key: ValueKey('username'),
                      validator: (value) {
                        if (value!.trim().isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                  TextFormField(
                    controller: _email,
                    autocorrect: false,
                    enableSuggestions: false,
                    textCapitalization: TextCapitalization.none,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.trim().isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  TextFormField(
                    controller: _password,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.trim().isEmpty || value.length < 7) {
                        return 'Password must be at least 7 characters';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 12),
                  if (controller.isLoading)
                    const CircularProgressIndicator(),
                  if (!controller.isLoading)
                    ElevatedButton(
                      child: Text(
                        controller.isLogin
                          ? 'Login' 
                          : 'Register'
                      ),
                      onPressed: () => _submit(),
                    ),
                  if (!controller.isLoading)
                    TextButton(
                      child: Text(
                        controller.isLogin
                          ? 'Create new account'
                          : 'Already have an account'
                      ),
                      onPressed: () {
                        controller.changeAuthState();
                      },
                    ),
                ],
              ),
            ),
            
          ),
        ),
      ),
    );
  }
}