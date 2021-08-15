import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:chat_app/core/styles/icon_broken.dart';

// For TextFormField
Widget buildFormField({
  required TextEditingController controller,
  required TextInputType type,
  required Function validate,
  bool isPassword = false,
  required String label,
  required IconData prefix,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: type,
    obscureText: isPassword,
    style: TextStyle(fontSize: 20),
    validator: (value) => validate(value),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey),
      prefixIcon: Icon(prefix, color: Colors.grey),
      suffixIcon: suffix,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,//Get.theme.hintColor
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),    
  );
}

// For Text
Widget buildText({
  required String text,
  double? size,
  FontWeight? weight,
  String? family,
  Color? color,
  TextOverflow? overflow,
  bool isUpperCase = false,
  double? letterSpacing,
}) {
  return Text(
    isUpperCase ? text.toUpperCase() : text,
    style: TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: family,
      color: color,
      letterSpacing: letterSpacing,
    ),
    overflow: overflow,
  );
}

// For Image Picker
void showAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Select Image From:"),
    actions: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton.icon(
            icon: Icon(Icons.photo),
            label: Text('Gallery'),
            onPressed:  () {
              Navigator.pop(context);
            },
          ),
          TextButton.icon(
            icon: Icon(Icons.camera_alt),
            label: Text('Camera'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

// For Image Picker
void buildImagePickerBottomSheet({
  required Function onCameraPressed,
  required Function onGalleryPressed,
}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(10.0),
      child: Wrap(
        children: [
          Text(
            'Continue using',
            style: Get.textTheme.headline2!.copyWith(
              fontSize: 20.0,
              fontWeight: null,
            ),
          ),
          // buildText(
          //   text: 'Continue using',
          //   size: 20.0,
          //   color: Colors.black,
          // ),
          buildListTile(
            title: 'Camera',
            icon: IconBroken.Camera,//Icons.camera_alt,
            onTap: () => onCameraPressed(),
          ),
          buildListTile(
            title: 'Gallery',
            icon: IconBroken.Image,//Icons.image,
            onTap: () => onGalleryPressed(),
          ),
        ],
      ),
    ),
    backgroundColor: Get.theme.primaryColor,
  );
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
    //tileColor: Colors.grey[200],
    dense: true,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(20.0),
    // ),

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
      color: Get.theme.accentColor,//Colors.blue,
    ),
  );
}

// For Auth Error Message
String buildErrorMessage(String error) {
  if (error.contains('weak-password')) {
    return 'The password provided is too weak.';
  } else if (error.contains('email-already-in-use')) {
    return 'The account already exists for that email.';
  } else if (error.contains('user-not-found')) {
    return 'No user found for that email.';
  } else if (error.contains('wrong-password')) {
    return 'Wrong password provided for that user.';
  }
  return 'Error Occurred';
}

// For Circular Progress Indicator
Widget showCircularProgress() {
  return SpinKitFadingCircle(
    color: Get.theme.accentColor,
  );
}

// For Snackbar
void showSnackbar(String title, String message) {
  Get.snackbar(
    title,
    message,
    borderRadius: 0,
    margin: EdgeInsets.all(0),
    backgroundColor: Colors.grey[900],
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );
}

// This function to build an empty widget
Widget buildEmptyView({required String text, required IconData icon}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 130,
          color: Get.theme.buttonColor,
        ),
        const SizedBox(height: 30),
        Text(
          text,
          style: Get.theme.textTheme.headline2!.copyWith(
            fontSize: 24.0,
          ),
        ),
        // buildText(
        //   text: text,
        //   color: Colors.black,
        //   size: 24,
        //   weight: FontWeight.bold,
        // ),
      ],
    )
  );
}

// For date converter "To Show The Date As Words" Like => Today
String buildDateConverter({required String messageDate}) {
  var dateFormat = DateFormat('d MMMM yyyy');

  var todayDate = dateFormat.format(DateTime.now());
  var yesterdayDate = dateFormat.format(DateTime.now().subtract(Duration(days: 1)));

  if (messageDate == todayDate) {
    return 'Today';
  } else if (messageDate == yesterdayDate) {
    return 'Yesterday';
  }
  return messageDate;
}

// For date format "To Show The Date Only" Like => 07 july 2021
String buildDateFormat({required String date}) {
  var dateFormat = DateFormat('d MMMM yyyy');
  return dateFormat.format(DateTime.parse(date));
}

// For time format "To Show The Time Only" Like => 07: 30 PM
String buildTimeFormat({required String date}) {
  if (date != '') {
    var dateFormat = DateFormat('hh:mm a');
    return dateFormat.format(DateTime.parse(date));
  }
  return date;
}

// For "CircleAvatar" with "CachedNetworkImage"
Widget buildCircleCachedImage({
  required String? imageUrl,
  required double radius
}) {
  return imageUrl != null
    ? CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) {
        return CircleAvatar(
          radius: radius,
          backgroundColor: Colors.grey[300],
          child: Icon(
            IconBroken.User, 
            size: 40.0,
            color: Theme.of(context).buttonColor
          ),
        );
      },
      imageBuilder: (context, imageProvider) {
        return CircleAvatar(
          radius: radius,
          backgroundImage: imageProvider,
        );
      },
      errorWidget: (context, url, error) {
        return CircleAvatar(
          radius: radius,
          child: Icon(Icons.image_not_supported),
        );
      },
    )
    : CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[300],
    );
}

// For users profile picture
Widget buildProfileImage({
  required String imageUrl,
  required bool isActive,
  required double radius,
  required double innerCircleSize,
  required double outerCircleSize,
  required double positionBottom,
  required double positionRight,
}) {
  return Stack(
    children: [
      buildCircleCachedImage(
        imageUrl: imageUrl,
        radius: radius,
      ),
      Positioned(
        bottom: positionBottom,
        right: positionRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Get.theme.primaryColor,//Colors.grey[200],
          ),
          constraints: BoxConstraints(
            minHeight: outerCircleSize,
            minWidth: outerCircleSize,
          ),
        ),
      ),
      Positioned(
        bottom: positionBottom,
        right: positionRight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: isActive
              ? Colors.green 
              : Colors.grey,
          ),
          constraints: BoxConstraints(
            minHeight: innerCircleSize,
            minWidth: innerCircleSize,
          ),
        ),
      ),
    ],
  );
}
