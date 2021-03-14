import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails extends StatelessWidget {
  final String mail;
  UserDetails({this.mail});

  @override
  Widget build(BuildContext context) {
    return FormScreen(
      mail: mail,
    );
  }
}

class FormScreen extends StatefulWidget {
  final String mail;
  FormScreen({this.mail});
  @override
  State<StatefulWidget> createState() {
    return FormScreenState();
  }
}

class FormScreenState extends State<FormScreen> {
  String _name;
  String _phone;
  String _branch;
  String _year;
  FirebaseFirestore fs = FirebaseFirestore.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void add(String n, String pno, String branch, String year) {
    fs.collection('Users').doc(widget.mail).set(
      {
        "Name": n,
        "PNO": pno,
        "Branch": branch,
        "Year": year,
        "Recieved Orders": [],
        "Cart": []
      },
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          email: widget.mail,
        ),
      ),
    );
  }

  Widget _buildName() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Name',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _name = value;
      },
    );
  }

  Widget _buildNumber() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Phone Number',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Phone Number is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _phone = value;
      },
    );
  }

  Widget _buildBranch() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Branch',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Branch is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _branch = value;
      },
    );
  }

  Widget _buildYear() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Year',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Year is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _year = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF71CDEF),
        appBar: AppBar(
          title: Text("Fill your Details"),
          backgroundColor: Color(0xFF71CDEF),
          elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildName(),
                SizedBox(height: 30),
                _buildNumber(),
                SizedBox(
                  height: 30,
                ),
                _buildBranch(),
                SizedBox(
                  height: 30,
                ),
                _buildYear(),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }

                    _formKey.currentState.save();
                    add(_name, _phone, _branch, _year);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
