import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '/data/controllers/auth_controller.dart';

class UserImagePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) => Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[400],
            backgroundImage: controller.getPickedImage != null
              ? FileImage(controller.getPickedImage!)
              : null,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () => controller.pickImage(ImageSource.camera),
                icon: Icon(Icons.photo_camera_outlined),
                label: Text('Add Image\nfrom Camera', textAlign: TextAlign.start),
              ),
              TextButton.icon(
                onPressed: () => controller.pickImage(ImageSource.gallery),
                icon: Icon(Icons.image_outlined),
                label: Text('Add Image\nfrom Gallery', textAlign: TextAlign.start),
              ),
            ],
          ),
        ],
      ),
    );
  }
}