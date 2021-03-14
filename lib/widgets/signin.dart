import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './myloader.dart';
import '../screens/home_screen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _email;
  bool showPassword = true;
  String _password;
  var fauth = FirebaseAuth.instance;
  TextEditingController t = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool showSpinner = false;

  Widget _buildTag(BuildContext c) {
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
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 3, color: Colors.red),
          ),
          filled: true,
          fillColor: Colors.black26,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Password is Required';
          }
          return null;
        },
        onSaved: (String value) {
          _password = value;
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
        primaryColor: Colors.red,
        accentColor: Colors.red,
      ),
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: ModalProgressHUD(
          opacity: 0.6,
          color: Colors.black87,
          inAsyncCall: showSpinner,
          progressIndicator: MyLoader(
            description: "Validating credentials",
          ),
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildTag(context),
                    SizedBox(height: 10),
                    _buildCmd(),
                    SizedBox(height: 30),
                    Container(
                      width: 240,
                      child: RaisedButton(
                        color: Colors.red.shade900,
                        child: Text(
                          'Sign In',
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
                            var user = await fauth.signInWithEmailAndPassword(
                                email: _email, password: _password);
                            if (user != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(
                                    email: _email,
                                  ),
                                ),
                              );
                            }
                            t.clear();
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
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
                                    "Invalid Credentials",
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
                                          "Check email or password",
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
