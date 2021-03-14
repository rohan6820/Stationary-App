import 'package:flutter/foundation.dart';

class Seller {
  final String name;
  final String branch;
  final String year;
  final String phoneNo;
  final List cart;

  Seller({
    @required this.name,
    @required this.branch,
    @required this.year,
    @required this.phoneNo,
    @required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Branch': branch,
      'PNO': phoneNo,
      'Year': year,
      'Cart': cart,
    };
  }

  Seller.fromFirestore(Map<String, dynamic> firestore)
      : name = firestore['Name'],
        branch = firestore['Branch'],
        phoneNo = firestore['PNO'],
        year = firestore['Year'],
        cart = firestore['Cart'];
}
