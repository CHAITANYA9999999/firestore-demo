import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String url;
  final String prodName;
  final String prodDescription;
  final String price;

  ProductModel({
    this.id,
    required this.url,
    required this.prodName,
    required this.prodDescription,
    required this.price,
  });

  toJson() {
    return {
      'prodName': prodName,
      'prodDescription': prodDescription,
      'price': price,
      'url': url
    };
  }

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return ProductModel(
      id: documentSnapshot.id,
      url: data['url'],
      price: data["price"],
      prodName: data["prodName"],
      prodDescription: data["prodDescription"],
    );
  }
}
