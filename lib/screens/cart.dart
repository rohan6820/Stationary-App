import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:HacktoberPS/models/Product.dart';
import 'package:HacktoberPS/models/Seller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:google_fonts/google_fonts.dart';

class CartPage extends StatefulWidget {
  final Seller seller;
  final String mail;

  CartPage({
    this.seller,
    this.mail,
  });

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ProductBLoc bloc = ProductBLoc();

  void removeLocalCartItem(String itemId) {
    int index = 0;
    for (var item in widget.seller.cart) {
      if (Product.fromFirestore(item).id == itemId) {
        break;
      }
      index += 1;
    }
    setState(() {
      widget.seller.cart.removeAt(index);
    });
  }

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
          GFButton(
            onPressed: () {
              bloc.removeItem(p.id, widget.mail);
              removeLocalCartItem(p.id);
            },
            blockButton: true,
            disabledColor: Colors.orange[50],
            color: Colors.red,
            disabledTextColor: Colors.black,
            textColor: Colors.white,
            child: Text("Remove"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart " + "(${widget.seller.cart.length})"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 7.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: widget.seller.cart.length,
            itemBuilder: (context, index) {
              var product = widget.seller.cart[index];
              Product p = Product.fromFirestore(product);
              return _buildProductCard(p);
            }),
      ),
    );
  }
}
