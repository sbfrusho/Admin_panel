import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../controller/category-dropdown-controller.dart';
import '../controller/edit-product-controller.dart';
import '../controller/is-sale-controller.dart';
import '../model/product-model.dart';

class EditProductScreen extends StatelessWidget {
  final ProductModel productModel;

  EditProductScreen({Key? key, required this.productModel}) : super(key: key);

  final IsSaleController isSaleController = Get.put(IsSaleController());
  final CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController salePriceController = TextEditingController();
  final TextEditingController fullPriceController = TextEditingController();
  final TextEditingController deliveryTimeController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    productNameController.text = productModel.productName;
    salePriceController.text = productModel.salePrice;
    fullPriceController.text = productModel.fullPrice;
    deliveryTimeController.text = productModel.deliveryTime;
    productDescriptionController.text = productModel.productDescription;

    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Edit Product ${productModel.productName}"),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                ),
                TextFormField(
                  controller: salePriceController,
                  decoration: InputDecoration(labelText: 'Sale Price'),
                ),
                TextFormField(
                  controller: fullPriceController,
                  decoration: InputDecoration(labelText: 'Full Price'),
                ),
                TextFormField(
                  controller: deliveryTimeController,
                  decoration: InputDecoration(labelText: 'Delivery Time'),
                ),
                TextFormField(
                  controller: productDescriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 20),
                // Category Dropdown
                GetBuilder<CategoryDropDownController>(
                  init: CategoryDropDownController(),
                  builder: (controller) {
                    return DropdownButtonFormField<String>(
                      value: controller.selectedCategoryId?.value,
                      onChanged: (value) {
                        controller.setSelectedCategory(value);
                      },
                      items: controller.categories
                          .map<DropdownMenuItem<String>>(
                            (category) => DropdownMenuItem<String>(
                              value: category['categoryId'],
                              child: Text(category['categoryName']),
                            ),
                          )
                          .toList(),
                      decoration: InputDecoration(labelText: 'Category'),
                    );
                  },
                ),
                SizedBox(height: 20),
                SwitchListTile(
                  title: Text("Is Sale"),
                  value: isSaleController.isSale.value,
                  onChanged: (value) {
                    isSaleController.toggleIsSale(value);
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'Updating Product...');

                    ProductModel updatedProduct = ProductModel(
                      productId: productModel.productId,
                      categoryId: categoryDropDownController
                          .selectedCategoryId.toString(),
                      productName: productNameController.text,
                      categoryName: categoryDropDownController
                          .selectedCategoryName.toString(),
                      salePrice: salePriceController.text,
                      fullPrice: fullPriceController.text,
                      productImages: productModel.productImages,
                      deliveryTime: deliveryTimeController.text,
                      isSale: isSaleController.isSale.value,
                      productDescription: productDescriptionController.text,
                      createdAt: productModel.createdAt,
                      updatedAt: DateTime.now(),
                    );

                    await controller.updateProduct(updatedProduct);

                    EasyLoading.dismiss();
                    Get.back();
                  },
                  child: Text('Update'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
