import '../screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './myloader.dart';
import '../screens/UserDetails.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var fauth = FirebaseAuth.instance;
  String _email;
  bool showPassword = true;
  String _password;
  String _cpassword;
  TextEditingController t = TextEditingController();
  TextEditingController p = TextEditingController();
  bool showSpinner = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTag() {
    return Container(
      width: 280,
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          prefixIcon: Icon(Icons.email),
          hintText: 'Email',
          filled: true,
          fillColor: Colors.black26,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Email is Required';
          }

          return null;
        },
        onSaved: (String value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildCmd() {
    return Container(
      width: 280,
      child: TextFormField(
        controller: t,
        obscureText: !showPassword,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          prefixIcon: Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: showPassword
                ? Icon(Icons.visibility_off)
                : Icon(Icons.visibility),
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
          ),
          hintText: 'Password',
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: Colors.red),
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          }
          return null;
        },
        onFieldSubmitted: (String value) {
          _password = value;
        },
      ),
    );
  }

  Widget _buildPs() {
    return Container(
      width: 280,
      child: TextFormField(
        controller: p,
        obscureText: !showPassword,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
          prefixIcon: Icon(Icons.lock),
          hintText: 'Confirm Password',
          filled: true,
          fillColor: Colors.black26,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: Colors.red),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (String value) {
          if (value != _password) {
            return 'Password is not matching';
          }
          return null;
        },
        onSaved: (String value) {
          _cpassword = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade800,
        accentColor: Colors.red,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ModalProgressHUD(
          opacity: 0.5,
          color: Colors.black,
          inAsyncCall: showSpinner,
          progressIndicator: MyLoader(
            description: "Creating User",
          ),
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildTag(),
                    SizedBox(height: 10),
                    _buildCmd(),
                    SizedBox(height: 10),
                    _buildPs(),
                    SizedBox(height: 20),
                    Container(
                      width: 280,
                      child: RaisedButton(
                        color: Colors.red.shade900,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          print("Submitted");
                          setState(() {
                            showSpinner = true;
                            showPassword = false;
                          });

                          try {
                            var user =
                                await fauth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            print(user);
                            print(user.additionalUserInfo.isNewUser);
                            if (user.additionalUserInfo.isNewUser) {
                              //Navigator.pushNamed(context, "terminal");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UserDetails(
                                    mail: _email,
                                  ),
                                ),
                              );
                            }
                            t.clear();
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            print(e);
                            setState(() {
                              showSpinner = false;
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  scrollable: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 30,
                                  backgroundColor: Colors.grey.shade800,
                                  title: Text(
                                    "User Exists",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Builder(
                                    builder: (context) {
                                      return Container(
                                        height: 46,
                                        width: 500,
                                        child: Text(
                                          "Please Login",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    RaisedButton(
                                      autofocus: true,
                                      disabledElevation: 50,
                                      color: Colors.grey,
                                      colorBrightness: Brightness.dark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        "Okay",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        t.clear();
                                        setState(() {
                                          Navigator.pop(ctx);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
