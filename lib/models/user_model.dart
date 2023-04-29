import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phoneNo;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.password,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "phoneNo": phoneNo,
      "password": password,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNo: json['phoneNo'],
      password: json['password'],
    );
  }
}
