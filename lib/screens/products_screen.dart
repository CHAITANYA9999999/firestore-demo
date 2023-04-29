import 'package:firestore/models/product_model.dart';
import 'package:firestore/repository/product_repository.dart';
import 'package:firestore/screens/edit_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'add_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var productRepository = Get.put(ProductRepository());
  ScrollController _scrollController = ScrollController();

  // var _isInit = false;

  // var _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productRepository.getProducts();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.25;
      if (maxScroll - currentScroll <= delta) {
        productRepository.getMoreProducts();
      }
    });
  }

  // @override
  // void didChangeDependencies() async {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   if (!_isInit) {
  //     _isLoading = true;
  //     await productRepository.getProducts();

  //     setState(() {
  //       _isLoading = false;
  //     });
  //     _isInit = true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: IconButton(
          icon: Icon(Icons.add), onPressed: () => Get.to(AddProductScreen())),
      body: Obx(() => ListView.builder(
                controller: _scrollController,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(),
                  title: Text(productRepository.products.value[index].prodName),
                  subtitle: Text('Description:' +
                      productRepository.products.value[index].prodDescription
                          .toString()),
                  trailing: Text('Price:' +
                      productRepository.products.value[index].price.toString()),
                ),
                itemCount: productRepository.products.value.length,
              )

          // GridView.builder(
          //   itemCount: productRepository.products.value.length,
          //   gridDelegate:
          //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          //   itemBuilder: (context, index) => Card(
          //     child: Center(
          //       child: Column(
          //         children: [
          //           Text('Name:' +
          //               productRepository.products.value[index].prodName
          //                   .toString()),
          //           Text('Price:' +
          //               productRepository.products.value[index].price.toString()),
          //           Text('Description:' +
          //               productRepository.products.value[index].prodDescription
          //                   .toString()),
          //           Text('Id:' +
          //               productRepository.products.value[index].id.toString()),
          //           IconButton(
          //               onPressed: () => productRepository.deleteProduct(
          //                   productRepository.products.value[index].id!),
          //               icon: Icon(Icons.delete)),
          //           IconButton(
          //               onPressed: () {
          //                 Get.to(EditProductScreen(),
          //                     arguments: productRepository.products.value[index]);
          //               },
          //               icon: Icon(Icons.edit)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
