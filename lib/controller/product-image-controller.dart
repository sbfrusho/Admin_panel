// import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class AddProductImagesController extends GetxController {
//   final ImagePicker _picker = ImagePicker();
//   RxList<XFile> selectedImages = <XFile>[].obs;
//   final RxList<String> arrImagesUrl = <String>[].obs;
//   final FirebaseStorage storageRef = FirebaseStorage.instance;

//   Future<void> showImagesPickerDialog() async {
//     print("showImagesPickerDialog");
//     PermissionStatus status = await _requestPermission();

//     if (status == PermissionStatus.granted) {
//       await _showDialog();
//     } else {
//       print("Error: Please allow permission for further usage");
//       openAppSettings();
//     }
//   }

//   Future<PermissionStatus> _requestPermission() async {
//     if (await Permission.mediaLibrary.request().isGranted) {
//       return PermissionStatus.granted;
//     } else {
//       return PermissionStatus.denied;
//     }
//   }

//   Future<void> _showDialog() async {
//     await Get.defaultDialog(
//       title: "Choose Image",
//       middleText: "Pick an image from the camera or gallery?",
//       actions: [
//         ElevatedButton(
//           onPressed: () async {
//             Get.back();
//             await selectImages("camera");
//           },
//           child: Text('Camera'),
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             Get.back();
//             await selectImages("gallery");
//           },
//           child: Text('Gallery'),
//         ),
//       ],
//     );
//   }

//   Future<void> selectImages(String type) async {
//     List<XFile> imgs = [];
//     try {
//       if (type == 'gallery') {
//         imgs = await _picker.pickMultiImage(imageQuality: 80);
//       } else {
//         final img =
//             await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
//         if (img != null) {
//           imgs.add(img);
//         }
//       }

//       if (imgs.isNotEmpty) {
//         selectedImages.addAll(imgs);
//         uploadImages(selectedImages);
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void uploadImages(RxList<XFile> images) async {
//     arrImagesUrl.clear();
//     for (int i = 0; i < images.length; i++) {
//       dynamic imageUrl = await uploadFile(images[i]);
//       arrImagesUrl.add(imageUrl.toString());
//     }
//   }

//   Future<String> uploadFile(XFile image) async {
//     TaskSnapshot reference = await storageRef
//         .ref()
//         .child("product-images")
//         .child(image.name + DateTime.now().toString())
//         .putFile(File(image.path));

//     return await reference.ref.getDownloadURL();
//   }

//   void removeImage(int index) {
//     selectedImages.removeAt(index);
//   }
// }

import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImagePickerController extends GetxController {
  final _picker = ImagePicker();
  final RxList<File> _selectedImages = <File>[].obs;
  final RxList<String> _uploadUrls = <String>[].obs;

  List<File> get selectedImages => _selectedImages;
  List<String> get uploadUrls => _uploadUrls;

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImages.add(File(pickedFile.path));
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadImages() async {
    try {
      for (var imageFile in _selectedImages) {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = ref.putFile(imageFile);
        await uploadTask.whenComplete(() async {
          final downloadUrl = await ref.getDownloadURL();
          _uploadUrls.add(downloadUrl);
        });
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  void removeImage(int index) {
    _selectedImages.removeAt(index);
  }

  @override
  void onClose() {
    _selectedImages.clear();
    _uploadUrls.clear();
    super.onClose();
  }
}

