import 'package:HacktoberPS/models/Product.dart';
import 'package:HacktoberPS/models/Seller.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:uuid/uuid.dart';

class FirestoreServices {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var uuid = Uuid();

  Stream<List<Product>> getStationaryData() {
    return db
        .collection("Products")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs)
        .map((snapshot) => snapshot.map((document) {
              return Product.fromFirestore(document.data());
            }).toList());
  }

  Stream<DocumentSnapshot> getSeller(String seller) {
    return db.collection("Users").doc(seller).snapshots();
  }

  Future<bool> addToCart(Product p, String seller) async {
    bool shouldAdd = true;
    await db.collection("Users").doc(seller).get().then((value) {
      Seller s = Seller.fromFirestore(value.data());
      for (var items in s.cart) {
        if (items["Id"] == p.id) {
          shouldAdd = false;
          break;
        }
      }
      if (shouldAdd) {
        s.cart.add(p.toMap());
        db.collection("Users").doc(seller).update(s.toMap());
      }
    });

    return shouldAdd;
  }

  void removeItemFromCart(String itemId, String mail) async {
    int index = 0;
    await db.collection("Users").doc(mail).get().then((value) {
      Seller s = Seller.fromFirestore(value.data());
      for (var items in s.cart) {
        if (items["Id"] == itemId) {
          break;
        }
        index += 1;
      }
      s.cart.removeAt(index);
      db.collection("Users").doc(mail).update(s.toMap());
    });
  }

  Stream<List<Product>> getSellerProducts(String mail) {
    return db
        .collection("Products")
        .where("Seller", isEqualTo: mail)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .where((element) => element.data().containsValue(0)))
        .map((snapshot) => snapshot.map((document) {
              print(document.data());
              return Product.fromFirestore(document.data());
            }).toList());
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<List<Product>> getBestMatches(String key) {
    List<Product> products = [];
    String query = capitalize(key);
    return db
        .collection("Products")
        .where("Name", isGreaterThanOrEqualTo: query)
        .get()
        .then((v) {
      v.docs
          .where((element) => element.data().containsValue(0))
          .forEach((element) {
        var productList = element.data();
        var d = productList["Name"].toString();
        if (d.contains(query.substring(0, 2))) {
          products.add(Product.fromFirestore(productList));
        }
      });
      return products;
    });
  }
}
