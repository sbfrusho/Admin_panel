// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_const_constructors, must_be_immutable, sized_box_for_whitespace, prefer_is_empty, avoid_print, await_only_futures

import 'dart:io';
import 'package:admin_panel/controller/product-image-controller.dart';
import 'package:admin_panel/screens/add-image.dart';
import 'package:admin_panel/widgets/drawer-widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/category-dropdown-controller.dart';
import '../controller/is-sale-controller.dart';
import '../model/product-model.dart';
import '../services/generate-ids.dart';
import '../widgets/drop-down-categories-widgets.dart';

class AddProductScreen extends StatefulWidget {
  AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ImagePickerController addProductImagesController =
      Get.put(ImagePickerController());

  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();

  TextEditingController salePriceController = TextEditingController();

  TextEditingController fullPriceController = TextEditingController();

  TextEditingController deliveryTimeController = TextEditingController();

  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: const Text("Add Products"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Select Images"),
                    ElevatedButton(
                      onPressed: () {
                        addProductImagesController.getImageFromGallery();
                      },
                      child: Text("Select Images"),
                    )
                  ],
                ),
              ),

              //show Images
              GetBuilder<ImagePickerController>(
                init: ImagePickerController(),
                builder: (imageController) {
                  return imageController.selectedImages.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedImages.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addProductImagesController
                                        .selectedImages[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImage(index);
                                        print(imageController
                                            .selectedImages.length);
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.close,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),

              //show categories drop down
              DropDownCategoriesWiidget(),

              //isSale
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Is Sale"),
                          Switch(
                            value: isSaleController.isSale.value,
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              //form
              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Name",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Sale Price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink();
              }),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Full Price",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Delivery Time",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    hintText: "Product Desc",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () async {
                  // print(productId);

                  try {
                    EasyLoading.show();
                    await addProductImagesController.uploadImages();
                    // print(addProductImagesController.uploadImages(.));

                    String productId = await GenerateIds().generateProductId();

                    ProductModel productModel = ProductModel(
                      productId: productId,
                      categoryId: categoryDropDownController.selectedCategoryId
                          .toString(),
                      productName: productNameController.text.trim(),
                      categoryName: categoryDropDownController
                          .selectedCategoryName
                          .toString(),
                      salePrice: salePriceController.text.trim(),
                      fullPrice: fullPriceController.text.trim(),
                      productImages: addProductImagesController.uploadUrls,
                      deliveryTime: deliveryTimeController.text.trim(),
                      isSale: isSaleController.isSale.value,
                      productDescription:
                          productDescriptionController.text.trim(),
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    await FirebaseFirestore.instance
                        .collection('products')
                        .doc(productId)
                        .set(productModel.toMap());
                    EasyLoading.dismiss();
                  } catch (e) {
                    print("error : $e");
                  }
                },
                child: Text("Upload"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
