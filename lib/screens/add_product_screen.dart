import 'dart:io';

import 'package:firestore/models/product_model.dart';
import 'package:firestore/models/user_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:firestore/screens/all_user_screen.dart';
import 'package:firestore/screens/login_screen.dart';
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

  Future<String> uploadFile(File file) async {
    String fileName = file.path.split('/').last;
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  Future<void> _takePicture() async {
    /// Provides an easy way to pick an image/video from the image library,
    /// or to take a picture/video with the camera.
    final picker = ImagePicker();

    /// Returns a [PickedFile] with the image that was picked.
    /// The `source` argument controls where the image comes from. This can
    /// be either [ImageSource.camera] or [ImageSource.gallery].
    final imageFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (imageFile == null) {
      return;
    }

    setState(() {
      //Get the path of the picked file, setState because we need to
      //show the image as soon as it is taken
      _storedImage = File(imageFile.path);
    });

    var url = await uploadFile(_storedImage!);
    print(url);

    // *To find what location we have to store our image, this storage
    // *is specifically reserved for app data
    // final appDirectory = await syspath.getApplicationDocumentsDirectory();

    // //*It stores the image name given by the app
    // final fileName = path.basename(imageFile.path);
    // final savedImage =
    //     await _storedImage!.copy('${appDirectory.path}/$fileName');
    // widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
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
                  // keyboardType: TextInputType.emailAddress,
                  controller: nameController,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid name!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
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
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  controller: descriptionController,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid description!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
                ),
                SizedBox(
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
                        ? Center(
                            child: Icon(Icons.camera),
                          )
                        : Container(
                            child: Image.file(
                            (_storedImage!),
                          )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('Create Product'),
                  onPressed: () async {
                    try {
                      await productRepository.addProduct(ProductModel(
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
                      // foregroundColor: MaterialStateProperty.all(
                      //     Theme.of(context).primaryColor),
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
