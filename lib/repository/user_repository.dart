import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore/models/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<bool> createUser(UserModel user) async {
    try {
      await _db
          .collection("Users")
          .add(user.toJson())
          .whenComplete(
              () => Get.snackbar("Done!!!", "Account create using firestore"))
          .catchError((error) => Get.snackbar("Error", error.toString()));
      return true;
    } on Exception catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<List<UserModel>> getAllUsers() async {
    return (await FirebaseFirestore.instance.collection("Users").get())
        .docs
        .map((item) => UserModel.fromJson(item.data()))
        .toList();
  }
}
