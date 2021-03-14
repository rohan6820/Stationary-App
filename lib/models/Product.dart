import 'package:flutter/foundation.dart';

class Product {
  var id;
  final String productName;
  final String imageURL;
  final String price;
  final String category;
  final String seller;
  bool selected = false;

  Product({
    @required this.productName,
    @required this.imageURL,
    @required this.price,
    @required this.category,
    @required this.seller,
  });

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'Name': productName,
      'Image': imageURL,
      'Price': price,
      'Category': category,
      'Seller': seller,
    };
  }

  Product.fromFirestore(Map<String, dynamic> firestore)
      : productName = firestore['Name'],
        imageURL = firestore['Image'],
        price = firestore['Price'],
        category = firestore['Category'],
        id = firestore['Id'],
        seller = firestore['Seller'];
}
