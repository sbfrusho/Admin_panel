// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ImagePickerController extends GetxController {
//   final ImagePicker _picker = ImagePicker();
//   RxList<XFile> selectedImages = <XFile>[].obs;

//   Future<void> showImagePickerDialog() async {
//     PermissionStatus status = await Permission.photos.request();

//     if (status == PermissionStatus.granted) {
//       Get.defaultDialog(
//         title: "Choose Image",
//         middleText: "Pick an image from the camera or gallery?",
//         actions: [
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               selectImage(ImageSource.camera);
//             },
//             child: Text('Camera'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Get.back();
//               selectImage(ImageSource.gallery);
//             },
//             child: Text('Gallery'),
//           ),
//         ],
//       );
//     } else {
//       print("Permission denied");
//     }
//   }

//   Future<void> selectImage(ImageSource source) async {
//     try {
//       XFile? image = await _picker.pickImage(source: source);
//       if (image != null) {
//         selectedImages.add(image);
//       }
//     } catch (e) {
//       print("Error selecting image: $e");
//     }
//   }

//   void removeImage(int index) {
//     selectedImages.removeAt(index);
//   }

//   Future<void> removeAllImages() async {
//     selectedImages.clear();
//   }
// }
