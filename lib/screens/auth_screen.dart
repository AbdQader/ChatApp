import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/controllers/auth_controller.dart';
//import '/widgets/auth/auth_form.dart';
//import '/widgets/pickers/user_image_picker.dart';
import '/core/styles/icon_broken.dart';
import '/core/utils/components.dart';

class AuthScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
        username: _usernameController.text, 
        email: _emailController.text, 
        password: _passwordController.text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).backgroundColor,
      //backgroundColor: Theme.of(context).primaryColor,
      //body: AuthForm(),
      body: MixinBuilder<AuthController>(
        init: AuthController(),
        builder: (controller) => Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20.0,
            top: 30.0
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.isLogin)
                      Text(
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      // buildText(
                      //   text: 'Welcome Back!',
                      //   size: 40.0,
                      //   weight: FontWeight.bold,
                      //   family: 'RobotoCondensed',
                      //   letterSpacing: 1.0,
                      // ),
                    if (!controller.isLogin)
                      Center(
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Get.theme.primaryColor,
                          backgroundImage: controller.getPickedImage != null
                            ? FileImage(controller.getPickedImage!)
                            : null,
                          child: InkWell(
                            onTap: () {
                              buildImagePickerBottomSheet(
                                onCameraPressed: () {
                                  controller.pickImage(ImageSource.camera);
                                  Get.back();
                                },
                                onGalleryPressed: () {
                                  controller.pickImage(ImageSource.gallery);
                                  Get.back();
                                },
                              );
                            },
                            child: controller.getPickedImage == null
                              ? Icon(Icons.add_a_photo, size: 50)
                              : null,
                          ),
                        ),
                      ),
                    const SizedBox(height: 30.0),
                    if (!controller.isLogin)
                      buildFormField(
                        controller: _usernameController,
                        type: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'Username must be at least 4 letters';
                          }
                          return null;
                        },
                        label: 'Username',
                        prefix: IconBroken.Profile,
                      ),
                    const SizedBox(height: 15.0),
                    buildFormField(
                      controller: _emailController,
                      type: TextInputType.emailAddress,
                      validate: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      label: 'Email Address',
                      prefix: IconBroken.Message,
                    ),
                    const SizedBox(height: 15.0),
                    buildFormField(
                      controller: _passwordController,
                      type: TextInputType.visiblePassword,
                      validate: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password is to short';
                        }
                        return null;
                      },
                      label: 'Password',
                      isPassword: controller.isPasswordVisible,
                      prefix: IconBroken.Lock,
                      suffix: IconButton(
                        onPressed: () {
                          controller.changePasswordVisibility();
                        },
                        icon: Icon(
                          controller.isPasswordVisible
                          ? IconBroken.Hide
                          : IconBroken.Show,
                          color: Colors.grey,
                        )
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (controller.isLoading)
                      Center(
                        child: const CircularProgressIndicator()
                      ),
                    if (!controller.isLoading)
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () => _submit(),
                          child: Text(
                            controller.isLogin
                              ? 'LOGIN'
                              : 'REGISTER',
                              style: Theme.of(context).textTheme.headline1!.copyWith(
                                color: Colors.white,
                              ),
                          ),
                          // child: buildText(
                          //   text: controller.isLogin
                          //     ? 'login'
                          //     : 'register',
                          //   size: 22.0,
                          //   color: Colors.white,
                          //   isUpperCase: true,
                          // ),
                        ),
                      ),
                    const SizedBox(height: 10.0),
                    if (!controller.isLoading)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.isLogin
                              ? 'Don\'t have an account?'
                              : 'Already have an account?',
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                fontSize: 18.0,
                                fontWeight: FontWeight.normal,
                              ),
                          ),
                          // buildText(
                          //   text: controller.isLogin
                          //     ? 'Don\'t have an account?'
                          //     : 'Already have an account?',
                          //   size: 18,
                          // ),
                          TextButton(
                            onPressed: () {
                              controller.changeAuthState();
                            },
                            child: Text(
                              controller.isLogin
                                ? 'REGISTER'
                                : 'LOGIN',
                                style: Theme.of(context).textTheme.headline2!.copyWith(
                                  fontSize: 18.0,
                                  color: Get.theme.accentColor
                                ),
                            ),
                            // child: buildText(
                            //   text: controller.isLogin
                            //     ? 'Register'
                            //     : 'Login',
                            //   size: 18,
                            //   isUpperCase: true,
                            //   weight: FontWeight.bold,
                            // ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}