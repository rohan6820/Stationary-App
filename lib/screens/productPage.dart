import 'package:HacktoberPS/models/Product.dart';
import 'package:HacktoberPS/models/Seller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:HacktoberPS/bloc/product_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductPage extends StatefulWidget {
  // final String image, category, name, seller;
  final Product product;
  final String mail;

  ProductPage({this.product, this.mail});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var mp;
  ProductBLoc bloc = ProductBLoc();
  FirebaseFirestore fs = FirebaseFirestore.instance;

  void updateReceivedOrders() async {
    await fs.collection("Users").doc(widget.product.seller).get().then((value) {
      var mp = Map();
      value.data().forEach((key, value) {
        if (key == "Recieved Orders") {
          mp[key] = value;
        }
      });
      print(mp);
      var s = mp["Recieved Orders"];
      print(s.runtimeType);
      s.add(widget.product.seller);

      fs
          .collection("Users")
          .doc(widget.product.seller)
          .update({'Recieved Orders': s});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: widget.product.productName,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 20.0,
                  ),
                ],
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AdvancedNetworkImage(
                    widget.product.imageURL,
                    useDiskCache: true,
                    cacheRule: CacheRule(
                      maxAge: Duration(days: 1),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(top: 30, left: 10),
                child: Text(
                  widget.product.productName,
                  style: GoogleFonts.bigShouldersDisplay(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Rs ${widget.product.price}.00",
                  style: GoogleFonts.oswald(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: bloc.getSeller(widget.product.seller),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              Seller s = Seller.fromFirestore(snapshot.data.data());
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                shadowColor: Colors.black,
                elevation: 10,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "SELLER DETAILS",
                          style: GoogleFonts.oswald(
                            fontSize: 36,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              "Name: ",
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              s.name,
                              style: GoogleFonts.anton(
                                fontSize: s.name.length < 20 ? 28 : 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              "Phone: ",
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              s.phoneNo,
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 8.0,
                          bottom: 2.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              "Branch: ",
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              s.branch,
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              " ${s.year}/4",
                              style: GoogleFonts.openSansCondensed(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 120,
                  height: 80,
                  child: FlatButton(
                    onPressed: () {
                      updateReceivedOrders();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.blue,
                    child: Text(
                      "Request Now",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 80,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () async {
                      bool show =
                          await bloc.updateCart(widget.product, widget.mail);
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
                    color: Colors.blue,
                    child: Text(
                      "Add To Cart",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
