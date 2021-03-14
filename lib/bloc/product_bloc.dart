import 'package:HacktoberPS/services/firestoreServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Product.dart';

class ProductBLoc {
  final db = FirestoreServices();

  Stream<List<Product>> get getData => db.getStationaryData();
  Stream<DocumentSnapshot> getSeller(seller) {
    return db.getSeller(seller);
  }

  Future<bool> updateCart(Product p, String seller) async {
    bool shouldAdd = await db.addToCart(p, seller);
    return shouldAdd;
  }

  void removeItem(String itemId, String mail) async {
    db.removeItemFromCart(itemId, mail);
  }

  Stream<List<Product>> getSellerData(mail) => db.getSellerProducts(mail);

  Future<List<Product>> getBestMatches(key) => db.getBestMatches(key);
}
