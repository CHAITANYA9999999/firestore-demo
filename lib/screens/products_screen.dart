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

  @override
  Widget build(BuildContext context) {
    // print('hello' + productRepository.products.value[2].url + 'hello');
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: IconButton(
          icon: Icon(Icons.add), onPressed: () => Get.to(AddProductScreen())),
      body: Obx(() => ListView.builder(
            controller: _scrollController,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                child: productRepository.products.value[index].url == null
                    ? null
                    : Image.network(
                        '${productRepository.products.value[index].url}'),
              ),
              title: Text(productRepository.products.value[index].prodName),
              subtitle: Text('Description:' +
                  productRepository.products.value[index].prodDescription
                      .toString()),
              trailing: Text('Price:' +
                  productRepository.products.value[index].price.toString()),
            ),
            itemCount: productRepository.products.value.length,
          )),
    );
  }
}
