import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:HacktoberPS/models/Product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MyProductsPage extends StatefulWidget {
  final String email;
  MyProductsPage({this.email});

  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage> {
  ProductBLoc pbloc = ProductBLoc();

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
        appBar: AppBar(
          title: Text("My Products"),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: StreamBuilder<List<Product>>(
            stream: pbloc.getSellerData(widget.email),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              //products = snapshot.data.docs;
              print(snapshot.data);
              return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 7.0,
                      mainAxisSpacing: 8.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var product = snapshot.data[index];
                    print(product);
                    return _buildProductCard(product);
                  });
            },
          ),
        ));
  }
}
