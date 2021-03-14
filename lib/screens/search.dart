import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:HacktoberPS/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  ProductBLoc bloc = ProductBLoc();
  List<Product> products = [];

  _buildProductCard(Product p) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(10.0),
      width: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: null,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Hero(
                  tag: p.productName,
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        child: Icon(Icons.image),
                      );
                    },
                    image: AdvancedNetworkImage(
                      p.imageURL,
                      useDiskCache: true,
                      cacheRule: CacheRule(
                        maxAge: Duration(days: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Text(
                p.productName,
                style: GoogleFonts.bigShouldersDisplay(
                    fontSize: 10, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Rs ${p.price}.00",
                style: GoogleFonts.oswald(
                    color: Colors.green, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
                bottom: 15.0, left: 15.0, right: 15.0, top: 50.0),
            child: Container(
              child: TextFormField(
                style: TextStyle(
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  prefixIcon: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  fillColor: Color(0xFFF0F0F0),
                  filled: true,
                  focusColor: Colors.black,
                  contentPadding: EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: const Color(0xFF7DB719), width: 0.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: const Color(0xFF7DB719)),
                  ),
                ),
                onChanged: (v) async {
                  if (v.length > 2) {
                    bloc.getBestMatches(v).then((value) {
                      setState(() {
                        products = value;
                      });
                    });
                  }
                },
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(products[index]);
                }),
          ),
        ],
      ),
    );
  }
}
