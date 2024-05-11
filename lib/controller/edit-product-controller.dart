// // ignore_for_file: file_names, avoid_print
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';

// import '../model/product-model.dart';

// class EditProductController extends GetxController {
//   ProductModel productModel;
//   EditProductController({
//     required this.productModel,
//   });
//   RxList<String> images = <String>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     getRealTimeImages();
//   }

//   void getRealTimeImages() {
//     FirebaseFirestore.instance
//         .collection('products')
//         .doc(productModel.productId)
//         .snapshots()
//         .listen((DocumentSnapshot snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data() as Map<String, dynamic>?;
//         if (data != null && data['productImages'] != null) {
//           images.value =
//               List<String>.from(data['productImages'] as List<dynamic>);
//           update();
//         }
//       }
//     });
//   }

//   //delete images
//   Future deleteImagesFromStorage(String imageUrl) async {
//     final FirebaseStorage storage = FirebaseStorage.instance;
//     try {
//       Reference reference = storage.refFromURL(imageUrl);
//       await reference.delete();
//     } catch (e) {
//       print("Error $e");
//     }
//   }

//   //collection
//   Future<void> deleteImageFromFireStore(
//       String imageUrl, String productId) async {
//     try {
//       await FirebaseFirestore.instance
//           .collection('products')
//           .doc(productId)
//           .update({
//         'productImages': FieldValue.arrayRemove([imageUrl])
//       });
//       update();
//     } catch (e) {
//       print("Error $e");
//     }
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../model/product-model.dart';

class EditProductController extends GetxController {
  late ProductModel _productModel;

  EditProductController({required ProductModel productModel}) {
    _productModel = productModel;
  }

  ProductModel get productModel => _productModel;

  Future<void> updateProduct(ProductModel updatedProduct) async {
    // Implement your logic to update the product in Firestore
    // For example:
    await FirebaseFirestore.instance
      .collection('products')
      .doc(updatedProduct.productId)
      .update(updatedProduct.toMap());

    // After updating the product, you can perform any necessary actions
    // such as showing a success message, navigating back, etc.
  }
}
