import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import '../widgets/myloader.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:getwidget/getwidget.dart';
import 'package:uuid/uuid.dart';

class UploadProduct extends StatefulWidget {
  final String email;
  UploadProduct({this.email});
  @override
  _UploadProductState createState() => _UploadProductState();
}

class _UploadProductState extends State<UploadProduct> {
  var fs = FirebaseFirestore.instance;
  String _category = "";
  String _item = "";
  String _price = "";
  var fa = FirebaseAuth.instance;
  bool showSpinner = false;
  var uuid = Uuid();
  String description = "Uploading Images";

  File imagefilepath;
  var imgurl;
  var furl;

  clickphoto() async {
    var picker = ImagePicker();

    await picker
        .getImage(
      source: ImageSource.camera,
    )
        .then((value) {
      setState(() {
        showSpinner = true;
      });
      var filename = basename(value.path);
      setState(() {
        imagefilepath = File(value.path);
      });

      FlutterNativeImage.compressImage(value.path,
              quality: 100, targetHeight: 600, targetWidth: 600)
          .then((value) {
        var fbstorage = FirebaseStorage.instance.ref().child(filename);
        fbstorage.putFile(value).onComplete.then((_) {
          FirestoreService.loadImage(filename).then((value) {
            furl = value.toString();
            setState(() {
              description = "Adding Product";
              showSpinner = false;
            });
          });
        });
      });
    });
  }

  void addPoduct(String name, String url, String price, String cat, String mail,
      BuildContext context) {
    fs.collection("Products").add(
      {
        "Name": name,
        "Id": uuid.v4(),
        "Price": price,
        "Category": cat,
        "Image": url,
        "Seller": mail,
        "State": 0,
      },
    ).then((_) {
      Navigator.of(context).pop();
      setState(() {
        showSpinner = false;
      });
    });
  }

  Widget _buildCategory() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          focusColor: Colors.green,
          labelText: 'Category',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Category is Required';
          }

          return null;
        },
        onChanged: (String value) {
          _category = value;
        },
      ),
    );
  }

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          focusColor: Colors.green,
          labelText: 'Product Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Item is Required';
          }

          return null;
        },
        onChanged: (String value) {
          _item = value;
        },
      ),
    );
  }

  Widget _buildPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          focusColor: Colors.green,
          labelText: 'Price',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Item is Required';
          }

          return null;
        },
        onChanged: (String value) {
          _price = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        elevation: 0,
        leading: GFIconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          type: GFButtonType.transparent,
        ),
        title: Center(child: Text("Add Product")),
        actions: <Widget>[
          GFIconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {},
            type: GFButtonType.transparent,
          ),
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        color: Colors.black,
        opacity: 0.7,
        progressIndicator: MyLoader(
          description: description,
        ),
        child: Center(
          child: SingleChildScrollView(
            // mainAxisAlignment: MainAxisAlignment.center,
            child: Column(
              children: <Widget>[
                _buildCategory(),
                SizedBox(
                  height: 20,
                ),
                _buildItem(),
                SizedBox(
                  height: 20,
                ),
                _buildPrice(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imagefilepath == null
                        ? AssetImage("images/addimage.png")
                        : FileImage(imagefilepath),
                  )),
                ),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });
                    addPoduct(
                        _item, furl, _price, _category, widget.email, context);
                    // setState(() {
                    //   showSpinner = false;
                    // });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          clickphoto();
        },
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class FirestoreService {
  FirestoreService();
  static Future<dynamic> loadImage(String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
