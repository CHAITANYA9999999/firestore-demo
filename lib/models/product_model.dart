import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String prodName;
  final String prodDescription;
  final String price;

  ProductModel({
    this.id,
    required this.prodName,
    required this.prodDescription,
    required this.price,
  });

  toJson() {
    return {
      'prodName': this.prodName,
      'prodDescription': this.prodDescription,
      'price': this.price,
    };
  }

  factory ProductModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return ProductModel(
      id: documentSnapshot.id,
      price: data["price"],
      prodName: data["prodName"],
      prodDescription: data["prodDescription"],
    );
  }
}
