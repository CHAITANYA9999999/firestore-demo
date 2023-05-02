import 'package:firestore/repository/auth_repository.dart';
import 'package:firestore/screens/products_screen.dart';
import 'package:firestore/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var auth = Get.put(AuthRepository1());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.addListener(() {});
    passwordController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email Number',
                  ),
                  controller: emailController,
                  validator: (value) {
                    if (value == null) {
                      return 'Invalid phone!';
                    }
                    return null;
                  },
                  onSaved: (value) {},
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
                  onSaved: (value) {},
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text('LOGIN'),
                  onPressed: () async {
                    try {
                      await auth.login(
                          emailController.text, passwordController.text);
                      Get.offAll(ProductsScreen());
                      Get.snackbar("Success", "Login Done Successfully");
                    } on Exception catch (e) {
                      // TODO
                      Get.defaultDialog(
                        title: 'Error!',
                        content: Text(e.toString()),
                        textConfirm: 'Okay',
                        onConfirm: () => Get.back(),
                      );
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
                ElevatedButton(
                  child: Text('SIGNUP INSTEAD'),
                  onPressed: () {
                    Get.offAll(SignUpScreen());
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
