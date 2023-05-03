import 'package:firestore/models/user_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:firestore/screens/all_user_screen.dart';
import 'package:firestore/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/auth_repository.dart';
import 'products_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  var userRepository = Get.put(UserRepository());
  var authRepository = Get.put(AuthRepository1());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.addListener(() {});
    phoneController.addListener(() {});
    passwordController.addListener(() {});
    emailController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.swap_horizontal_circle_sharp,
          ),
          onPressed: () async {
            Get.changeTheme(
              Get.isDarkMode ? ThemeData.light() : ThemeData.dark(),
            );
            setState(() {});
          },
        ),
      ),
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
                    labelText: 'E-Mail',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),
                  // keyboardType: TextInputType.emailAddress,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid phone!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    // _authData['password'] = value!;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('SIGNUP'),
                  onPressed: () async {
                    try {
                      var response = await authRepository.signup(
                          emailController.text, passwordController.text);

                      UserModel user = UserModel(
                          name: nameController.text,
                          email: emailController.text,
                          phoneNo: phoneController.text,
                          password: passwordController.text);
                      bool result = await userRepository.createUser(user);

                      if (result) {
                        Get.off(ProductsScreen());
                      }
                    } on Exception catch (e) {
                      print(e.toString());
                      Get.snackbar("Error", e.toString());
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
                ElevatedButton(
                  child: Text('LOGIN INSTEAD'),
                  onPressed: () {
                    Get.offAll(LoginScreen());
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
