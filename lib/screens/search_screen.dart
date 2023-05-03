import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import '../repository/product_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  var productRepository = ProductRepository();

  @override
  void initState() {
    // TODO: implement initState
    searchController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: TextFormField(
              controller: searchController,
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      child: productRepository.products.value[index].url == null
                          ? null
                          : Image.network(
                              '${productRepository.products.value[index].url}'),
                    ),
                    title:
                        Text(productRepository.products.value[index].prodName),
                    subtitle: Text('Description:' +
                        productRepository.products.value[index].prodDescription
                            .toString()),
                    trailing: Text('Price:' +
                        productRepository.products.value[index].price
                            .toString()),
                  ),
                  itemCount: productRepository.products.value.length,
                )),
          ),
        ],
      ),
    );
  }
}
