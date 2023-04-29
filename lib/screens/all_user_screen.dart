import 'package:firestore/models/user_model.dart';
import 'package:firestore/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class AllUserScreen extends StatefulWidget {
  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  var _isInit = false;

  var _isLoading = true;
  var allUserRepository = Get.put(UserRepository());
  List<UserModel> list = [];

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!_isInit) {
      _isLoading = true;
      list = await UserRepository.getAllUsers();
      setState(() {
        _isLoading = false;
      });
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GridView.builder(
        itemCount: list.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) => Card(
          child: Center(
            child: Column(
              children: [
                Text('Name:' + list[index].name.toString()),
                Text('Email:' + list[index].email.toString()),
                Text('Phone:' + list[index].phoneNo.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
