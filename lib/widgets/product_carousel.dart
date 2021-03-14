import 'dart:ui';
import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:HacktoberPS/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCarousel extends StatelessWidget {
  final String title;
  final List<Product> products;
  final BuildContext context;
  final Function navigate;
  final ProductBLoc bloc = ProductBLoc();
  final mail;

  ProductCarousel(
      {this.title, this.products, this.context, this.navigate, this.mail});

  _buildProductCard(int index) {
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
              onTap: navigate != null
                  ? () {
                      navigate(index, products);
                    }
                  : null,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: Hero(
                  tag: products[index].productName,
                  child: Image(
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        child: Icon(Icons.image),
                      );
                    },
                    image: AdvancedNetworkImage(
                      products[index].imageURL,
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
          SizedBox(height: 10.0),
          Column(
            children: [
              Text(
                products[index].productName,
                style: GoogleFonts.bigShouldersDisplay(
                    fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Rs ${products[index].price}.00",
                style: GoogleFonts.oswald(
                    color: Colors.green, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          GFButton(
            onPressed: () async {
              bool show = await bloc.updateCart(products[index], mail);
              if (!show) {
                Fluttertoast.showToast(
                    msg: "Already added to Cart",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.grey[300],
                    textColor: Colors.black,
                    fontSize: 16.0);
              } else {
                Fluttertoast.showToast(
                    msg: "Added to Cart",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            blockButton: true,
            disabledColor: Colors.orange[50],
            color: Colors.deepOrange,
            disabledTextColor: Colors.black,
            textColor: Colors.white,
            child: Text("Add To Cart"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          height: 280.0,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildProductCard(index);
            },
          ),
        ),
      ],
    );
  }
}
