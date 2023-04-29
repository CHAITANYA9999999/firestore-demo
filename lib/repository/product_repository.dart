import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxController {
  RxList<ProductModel> products = <ProductModel>[].obs;

  bool hasMore = true; // flag for more products available or not
  int documentLimit = 15; // documents to be fetched per request
  DocumentSnapshot?
      lastDocument; // flag for last document from where next 10 records to be fetched
  ScrollController _scrollController =
      ScrollController(); // listener for listview scrolling

  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;

  Future<void> getAllProducts() async {
    var response =
        (await FirebaseFirestore.instance.collection("Products").get())
            .docs
            .map((item) => ProductModel.fromSnapshot(item))
            .toList();
    products.value = response;
  }

  getProducts() async {
    Query q = FirebaseFirestore.instance
        .collection("Products")
        .orderBy('price')
        .limit(documentLimit);

    QuerySnapshot _querySnapshot = await q.get();
    lastDocument = _querySnapshot.docs[_querySnapshot.docs.length - 1];
    print(lastDocument!.data());

    products.value = _querySnapshot.docs
        .map((item) => ProductModel.fromSnapshot(
            item as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  getMoreProducts() async {
    if (_moreProductsAvailable == false) {
      return;
    }

    if (_gettingMoreProducts == true) {
      //*It means that we are in between the process of getting more products
      return;
    }
    print('getting more products');

    _gettingMoreProducts = true;

    Query q = FirebaseFirestore.instance
        .collection("Products")
        .orderBy('price')
        .startAfter([lastDocument!['price']]).limit(documentLimit);

    QuerySnapshot _querySnapshot = await q.get();
    if (_querySnapshot.docs.length < documentLimit) {
      _moreProductsAvailable = false;
    }
    products.addAll(_querySnapshot.docs.map((item) => ProductModel.fromSnapshot(
        item as DocumentSnapshot<Map<String, dynamic>>)));

    _gettingMoreProducts = false;
  }

  Future<void> addProduct(ProductModel product) async {
    final response = await FirebaseFirestore.instance
        .collection("Products")
        .add(product.toJson());

    products.add(ProductModel(
        prodName: product.prodName,
        prodDescription: product.prodDescription,
        price: product.price,
        id: response.id));
  }

  Future<void> updateProduct(String documentId, ProductModel product) async {
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(documentId)
        .update(product.toJson());

    for (int i = 0; i < products.value.length; i++) {
      if (products[i].id == documentId) {
        print('running!!!!!!!!!!!!!!');
        products[i] = ProductModel(
            prodName: product.prodName,
            prodDescription: product.prodDescription,
            price: product.price,
            id: documentId);
        break;
      }
    }
    update();
  }

  Future<void> deleteProduct(String documentId) async {
    await FirebaseFirestore.instance
        .collection("Products")
        .doc(documentId)
        .delete();
    products.removeWhere((element) => element.id == documentId);
  }
}
