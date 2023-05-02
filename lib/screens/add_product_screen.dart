import 'dart:io';

import 'package:firestore/models/product_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firebase_storage/firebase_storage.dart';

import '../repository/auth_repository.dart';
import '../repository/product_repository.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  var userRepository = Get.put(UserRepository());
  var authRepository = Get.put(AuthRepository1());
  var productRepository = Get.put(ProductRepository());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.addListener(() {});
    descriptionController.addListener(() {});
    priceController.addListener(() {});
  }

  File? _storedImage;
  String? image_url;

  Future<String> uploadFile(File file) async {
    print(file);
    String fileName = file.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    try {
      await ref.putFile(File(file.path));
      var url = await ref.getDownloadURL();
      print(url);
      return url;
    } on Exception catch (e) {
      Get.dialog(Text(e.toString()));
    }

    return '';
  }

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = File(imageFile.path);
    });

    var url = await uploadFile(_storedImage!);
    image_url = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
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
                  decoration: const InputDecoration(
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
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
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
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () => _takePicture(),
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: _storedImage == null
                        ? const Center(
                            child: Icon(Icons.camera),
                          )
                        : Container(
                            child: Image.file(
                            (_storedImage!),
                          )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create Product'),
                  onPressed: () async {
                    try {
                      await productRepository.addProduct(ProductModel(
                          prodName: nameController.text,
                          prodDescription: descriptionController.text,
                          url: image_url ?? "",
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
