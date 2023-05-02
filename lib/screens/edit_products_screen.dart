import 'package:firestore/models/product_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/auth_repository.dart';
import '../repository/product_repository.dart';

class EditProductScreen extends StatefulWidget {
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var data = Get.arguments as ProductModel;

  late TextEditingController nameController;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  var userRepository = Get.put(UserRepository());
  var authRepository = Get.put(AuthRepository1());
  var productRepository = Get.put(ProductRepository());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: data.prodName);
    descriptionController = TextEditingController(text: data.prodDescription);
    priceController = TextEditingController(text: data.price);
    nameController.addListener(() {});
    descriptionController.addListener(() {});
    priceController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                  ),
                  controller: nameController,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid name!';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: priceController,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid price!';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  controller: descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid description!';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Save Changes'),
                  onPressed: () async {
                    try {
                      await productRepository.updateProduct(
                          data.id!,
                          ProductModel(
                              url: data.url,
                              prodName: nameController.text,
                              prodDescription: descriptionController.text,
                              price: priceController.text));
                      Get.back();
                    } catch (e) {
                      Get.dialog(Text(e.toString()));
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
