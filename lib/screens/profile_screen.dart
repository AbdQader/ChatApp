import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/controllers/theme_controller.dart';
import '/data/controllers/user_controller.dart';
import '/core/styles/icon_broken.dart';
import '/core/utils/components.dart';

class ProfileScreen extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final _newUsername = TextEditingController();
  final _newEmail = TextEditingController();
  final _newPassword = TextEditingController();
  final _oldPassword = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final isLandscape = Get.mediaQuery.orientation == Orientation.landscape;
    final controller = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: Get.theme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(IconBroken.Arrow___Left, size: 30),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).buttonColor,
        ),
        actions: [
          Obx(() => IconButton(
              onPressed: () => controller.changeThemeMode(),
              icon: Icon(
                controller.themeMode == ThemeMode.dark
                ? Icons.brightness_2
                : Icons.wb_sunny,
                color: Get.theme.buttonColor,
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<UserController>(
        builder: (controller) => Padding(
          padding: EdgeInsets.all(20.0),
          child: isLandscape
            ? Row(
                children: buildProfileContent(controller),
              )
            : Column (
                children: buildProfileContent(controller),
              ),
        ),
      ),
      
      // body: GetBuilder<UserController>(
      //   builder: (controller) => Padding(
      //     padding: EdgeInsets.all(20.0),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Stack(
      //             children: [
      //               buildCircleCachedImage(
      //                 imageUrl: controller.user.image!,
      //                 radius: 50.0,
      //               ),
      //               Positioned(
      //                 bottom: 5.0,
      //                 right: 1.0,
      //                 child: InkWell(
      //                   onTap: () => buildImagePickerBottomSheet(
      //                     onCameraPressed: () {
      //                       controller.updateUserImage(
      //                         src: ImageSource.camera
      //                       );
      //                       Get.back();
      //                     },
      //                     onGalleryPressed: () {
      //                       controller.updateUserImage(
      //                         src: ImageSource.gallery
      //                       );
      //                       Get.back();
      //                     },
      //                   ),
      //                   child: CircleAvatar(
      //                     radius: 16.0,
      //                     child: Icon(Icons.edit, size: 18.0),
      //                   ),
      //                 ),
      //               ),
      //             ]
      //           ),
      //           const SizedBox(height: 10.0),
      //           buildText(
      //             text: controller.user.username!,
      //             size: 24.0,
      //             color: Colors.black,
      //             weight: FontWeight.bold,
      //           ),
      //           const SizedBox(height: 5.0),
      //           buildText(
      //             text: controller.user.email!,
      //             size: 20.0,
      //           ),
      //           const SizedBox(height: 50.0),
      //           buildListTile(
      //             title: 'Edit Username',
      //             icon: IconBroken.Profile,
      //             onTap: () {
      //               showBottomSheet(
      //                 controller: _newUsername,
      //                 label: 'New Username',
      //                 icon: IconBroken.Profile,
      //                 type: TextInputType.name,
      //                 validate: (value) {
      //                   if (value.trim().isEmpty || value.length < 4)
      //                     return 'Please enter at least 4 characters';
      //                   return null;
      //                 },
      //                 onSave: () {
      //                   if (_formKey.currentState!.validate())
      //                   {
      //                     controller.updateUsername(
      //                       newUsername: _newUsername.text.trim(),
      //                       password: _oldPassword.text
      //                     );
      //                     _newUsername.clear();
      //                     _oldPassword.clear();
      //                     Get.back();
      //                   }
      //                 },
      //               );
      //             },
      //           ),
      //           const SizedBox(height: 20.0),
      //           buildListTile(
      //             title: 'Edit Email',
      //             icon: IconBroken.Message,
      //             onTap: () {
      //               showBottomSheet(
      //                 controller: _newEmail,
      //                 label: 'New Email',
      //                 icon: IconBroken.Message,
      //                 type: TextInputType.emailAddress,
      //                 validate: (value) {
      //                   if (value.trim().isEmpty || !value.contains('@'))
      //                     return 'Please enter a valid email address';
      //                   return null;
      //                 },
      //                 onSave: () {
      //                   if (_formKey.currentState!.validate())
      //                   {
      //                     controller.updateUserEmail(
      //                       newEmail: _newEmail.text.trim(),
      //                       password: _oldPassword.text
      //                     );
      //                     _newEmail.clear();
      //                     _oldPassword.clear();
      //                     Get.back();
      //                   }
      //                 },
      //               );
      //             },
      //           ),
      //           const SizedBox(height: 20.0),
      //           buildListTile(
      //             title: 'Edit Password',
      //             icon: IconBroken.Lock,
      //             onTap: () {
      //               showBottomSheet(
      //                 controller: _newPassword,
      //                 label: 'New Password',
      //                 icon: IconBroken.Lock,
      //                 type: TextInputType.visiblePassword,
      //                 isPassword: true,
      //                 validate: (value) {
      //                   if (value.trim().isEmpty || value.length < 4)
      //                     return 'Please enter at least 4 characters';
      //                   return null;
      //                 },
      //                 onSave: () {
      //                   if (_formKey.currentState!.validate())
      //                   {
      //                     controller.updateUserPassword(
      //                       newPassword: _newPassword.text.trim(),
      //                       password: _oldPassword.text
      //                     );
      //                     _newPassword.clear();
      //                     _oldPassword.clear();
      //                     Get.back();
      //                   }
      //                 },
      //               );
      //             },
      //           ),
      //           const SizedBox(height: 20.0),
      //           buildListTile(
      //             title: 'Logout',
      //             icon: IconBroken.Logout,
      //             onTap: () {
      //               showAlertDialog(action: controller.logout);
      //             },
      //           ),
      //           // Container(
      //           //   width: double.infinity,
      //           //   child: ElevatedButton(
      //           //     onPressed: () {
      //           //       showAlertDialog(action: controller.logout);
      //           //     },
      //           //     child: Padding(
      //           //       padding: const EdgeInsets.all(15.0),
      //           //       child: buildText(
      //           //         text: 'Logout',
      //           //         size: 20.0,
      //           //         color: Colors.white,
      //           //         weight: FontWeight.bold,
      //           //       ),
      //           //     ),
      //           //   ),
      //           // ),

      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  List<Widget> buildProfileContent(UserController controller) {
    var isLandscape = Get.mediaQuery.orientation == Orientation.landscape;
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              buildCircleCachedImage(
                imageUrl: controller.user.image!,
                radius: 50.0,
              ),
              Positioned(
                bottom: 5.0,
                right: 1.0,
                child: InkWell(
                  onTap: () => buildImagePickerBottomSheet(
                    onCameraPressed: () {
                      controller.updateUserImage(
                        src: ImageSource.camera
                      );
                      Get.back();
                    },
                    onGalleryPressed: () {
                      controller.updateUserImage(
                        src: ImageSource.gallery
                      );
                      Get.back();
                    },
                  ),
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Get.theme.accentColor,
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18.0
                    ),
                  ),
                ),
              ),
            ]
          ),
          const SizedBox(height: 10.0),
          Text(
            controller.user.username!,
            style: Get.textTheme.headline2!.copyWith(
              fontSize: 24.0
            ),
          ),
          // buildText(
          //   text: controller.user.username!,
          //   size: 24.0,
          //   color: Colors.black,
          //   weight: FontWeight.bold,
          // ),
          const SizedBox(height: 5.0),
          Text(
            controller.user.email!,
            style: Get.textTheme.headline3!.copyWith(
              fontSize: 20.0
            ),
          ),
          // buildText(
          //   text: controller.user.email!,
          //   size: 20.0,
          // ),
        ],
      ),
      if (isLandscape)
        const SizedBox(width: 20),
      if (!isLandscape)
        const SizedBox(height: 30),
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildListTile(
                title: 'Edit Username',
                icon: IconBroken.Profile,
                onTap: () {
                  showBottomSheet(
                    controller: _newUsername,
                    label: 'New Username',
                    icon: IconBroken.Profile,
                    type: TextInputType.name,
                    validate: (value) {
                      if (value.trim().isEmpty || value.length < 4)
                        return 'Please enter at least 4 characters';
                      return null;
                    },
                    onSave: () {
                      if (_formKey.currentState!.validate())
                      {
                        controller.updateUsername(
                          newUsername: _newUsername.text.trim(),
                          password: _oldPassword.text
                        );
                        _newUsername.clear();
                        _oldPassword.clear();
                        Get.back();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20.0),
              buildListTile(
                title: 'Edit Email',
                icon: IconBroken.Message,
                onTap: () {
                  showBottomSheet(
                    controller: _newEmail,
                    label: 'New Email',
                    icon: IconBroken.Message,
                    type: TextInputType.emailAddress,
                    validate: (value) {
                      if (value.trim().isEmpty || !value.contains('@'))
                        return 'Please enter a valid email address';
                      return null;
                    },
                    onSave: () {
                      if (_formKey.currentState!.validate())
                      {
                        controller.updateUserEmail(
                          newEmail: _newEmail.text.trim(),
                          password: _oldPassword.text
                        );
                        _newEmail.clear();
                        _oldPassword.clear();
                        Get.back();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20.0),
              buildListTile(
                title: 'Edit Password',
                icon: IconBroken.Lock,
                onTap: () {
                  showBottomSheet(
                    controller: _newPassword,
                    label: 'New Password',
                    icon: IconBroken.Lock,
                    type: TextInputType.visiblePassword,
                    isPassword: true,
                    validate: (value) {
                      if (value.trim().isEmpty || value.length < 4)
                        return 'Please enter at least 4 characters';
                      return null;
                    },
                    onSave: () {
                      if (_formKey.currentState!.validate())
                      {
                        controller.updateUserPassword(
                          newPassword: _newPassword.text.trim(),
                          password: _oldPassword.text
                        );
                        _newPassword.clear();
                        _oldPassword.clear();
                        Get.back();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 20.0),
              buildListTile(
                title: 'Logout',
                icon: IconBroken.Logout,
                onTap: () {
                  showAlertDialog(action: controller.logout);
                },
              ),
            ],
          ),
        ),
      )
    ];
  }

  // For ListTile
  Widget buildListTile({
    required String title,
    required IconData icon,
    required Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.all(10.0),
      tileColor: Get.theme.primaryColor,
      dense: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text(
        title,
        style: Get.theme.textTheme.headline2,
      ),
      // title: buildText(
      //   text: title,
      //   size: 18.0,
      //   color: Colors.black,
      //   weight: FontWeight.bold,
      // ),
      leading: Icon(
        icon,
        size: 25,
        color: Get.theme.accentColor,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 25,
        color: Get.theme.buttonColor,
      ),
    );
  }

  // For edit user info
  void showBottomSheet({
    required TextEditingController controller,
    required TextInputType type,
    required String label,
    required IconData icon,
    required Function onSave,
    required Function validate,
    bool isPassword = false
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildFormField(
                  controller: controller,
                  type: TextInputType.name,
                  validate: (value) => validate(value),
                  label: label,
                  prefix: icon,
                  isPassword: isPassword,
                ),
                const SizedBox(height: 20),
                GetBuilder<UserController>(
                  builder: (userController) => buildFormField(
                    controller: _oldPassword,
                    type: TextInputType.visiblePassword,
                    validate: (value) {
                      if (value.trim().isEmpty || value.length < 7)
                        return 'Password must be at least 7 characters';
                      if (value.trim() != userController.user.password)
                        return 'Passwords not match';
                      return null;
                    },
                    label: 'Confirm Password',
                    prefix: IconBroken.Lock,
                    suffix: IconButton(
                      onPressed: () {
                        userController.changePasswordVisibility();
                      },
                      icon: Icon(
                        userController.isPasswordVisible
                        ? IconBroken.Hide
                        : IconBroken.Show,
                        color: Colors.grey,
                      )
                    ),
                    isPassword: userController.isPasswordVisible,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onSave(),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        'SAVE',
                        style: Get.textTheme.headline1!.copyWith(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      // child: buildText(
                      //   text: 'Save',
                      //   size: 20.0,
                      //   color: Colors.white,
                      //   weight: FontWeight.bold,
                      //   isUpperCase: true,
                      // ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Get.theme.primaryColor,
      //barrierColor: Colors.black.withOpacity(0.1),
    );
    
  }

  // For logout the user
  void showAlertDialog({required Function action}) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Get.theme.primaryColor,
        title: Text(
          'Do you want to logout?',
          style: Get.textTheme.headline3,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: Text('CANCEL'),
                // child: buildText(
                //   text: 'CANCEL',
                //   color: Colors.black87,
                // ),
                onPressed:  () {
                  Get.back();
                },
              ),
              TextButton(
                child: Text('LOGOUT'),
                onPressed: () async {
                  await action();
                  Get.back(closeOverlays: true);
                },
              ),
            ],
          ),
        ],
      ),
      //barrierColor: Colors.black.withOpacity(0.1),
    );
  }

}