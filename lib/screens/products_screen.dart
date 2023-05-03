import 'package:firestore/repository/product_repository.dart';
import 'package:firestore/screens/search_screen.dart';
import 'package:flutter/material.dart';
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
            await Get.forceAppUpdate();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () => Get.to(() => SearchScreen()),
          )
        ],
      ),
      floatingActionButton: IconButton(
          icon: Icon(Icons.add), onPressed: () => Get.to(AddProductScreen())),
      body: Obx(() => Container(
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) => Container(
                height: 100,
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 40,
                      child: productRepository.products.value[index].url == null
                          ? null
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${productRepository.products.value[index].url}'),
                                    fit: BoxFit.fill),
                              ),
                            )),
                  title: Text(productRepository.products.value[index].prodName),
                  subtitle: Text('Description:' +
                      productRepository.products.value[index].prodDescription
                          .toString()),
                  trailing: Text('Price:' +
                      productRepository.products.value[index].price.toString()),
                ),
              ),
              itemCount: productRepository.products.value.length,
            ),
          )),
    );
  }
}
