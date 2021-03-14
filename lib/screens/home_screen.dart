import 'package:HacktoberPS/models/Product.dart';
import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:HacktoberPS/models/Seller.dart';
import 'package:HacktoberPS/screens/cart.dart';
import 'package:HacktoberPS/screens/myProducts.dart';
import 'package:HacktoberPS/screens/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './productPage.dart';
import 'package:flutter/material.dart';
import '../widgets/product_carousel.dart';
import 'profile.dart';
import '../widgets/myspeeddail.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  HomeScreen({this.email});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProductBLoc bloc = ProductBLoc();

  void openProductInfo(int index, List<Product> products) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductPage(
          product: products[index],
          mail: widget.email,
        ),
      ),
    );
  }

  Widget appBarActions() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0, right: 20.0),
          child: InkResponse(
            onTap: () {},
            child: Icon(
              Icons.shopping_basket,
              size: 30.0,
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          bottom: 8.0,
          right: 16.0,
          child: InkResponse(
            child: Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Center(
                child: Text(
                  "0",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: bloc.getSeller(widget.email),
              builder: (context, snapshot) {
                if (!snapshot.hasData) appBarActions();

                Seller s = Seller.fromFirestore(snapshot.data.data());
                return InkResponse(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CartPage(
                          seller: s,
                          mail: widget.email,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 12.0, right: 20.0),
                        child: Icon(
                          Icons.shopping_cart_rounded,
                          size: 30.0,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        bottom: 8.0,
                        right: 16.0,
                        child: InkResponse(
                          child: Container(
                            height: 20.0,
                            width: 20.0,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(9.0),
                            ),
                            child: Center(
                              child: Text(
                                s.cart.length.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: InkResponse(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MySearchPage(),
                  ),
                );
              },
              child: Icon(
                Icons.search,
                size: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Image(
                image: NetworkImage(
                    'https://img.scoop.it/_y8pIct3Bgk-da_9ldpb1jl72eJkfbmt4t8yenImKBVvK0kTmF0xjctABnaLJIm9'),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          StreamBuilder<List<Product>>(
              stream: bloc.getData,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                Map<String, List<Product>> mp = {};
                List<ProductCarousel> categories = [];

                for (var d in snapshot.data) {
                  if (mp[d.category] == null) {
                    mp[d.category] = [];
                  }
                  mp[d.category].add(d);
                }
                mp.forEach((key, value) {
                  categories.add(
                    ProductCarousel(
                      mail: widget.email,
                      title: key,
                      products: value,
                      navigate: openProductInfo,
                    ),
                  );
                });

                return Column(
                  children: categories,
                );
              }),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('<Buyer Name>'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Profile'),
              leading: Icon(Icons.account_box),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(email: widget.email),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('My Products'),
              leading: Icon(Icons.history),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyProductsPage(email: widget.email),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: MySpeedDail(
        mail: widget.email,
      ),
    );
  }
}
