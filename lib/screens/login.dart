import 'package:flutter/material.dart';
import '../widgets/signin.dart';
import '../widgets/signup.dart';
import '../widgets/logo.dart';

class MyLogin extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        margin: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              height: 400,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: DefaultTabController(
                  length: 2,
                  initialIndex: 0,
                  child: Column(
                    children: <Widget>[
                      Logo(),
                      SizedBox(
                        height: 70,
                      ),
                      Container(
                        width: 240,
                        height: 40,
                        child: TabBar(
                          unselectedLabelStyle: TextStyle(fontSize: 12),
                          labelStyle: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          indicatorColor: Colors.red,
                          unselectedLabelColor: Colors.white,
                          labelColor: Colors.red,
                          tabs: <Widget>[
                            Tab(text: "Sign in"),
                            Tab(text: "Sign up"),
                          ],
                        ),
                      ),
                      Material(
                        //elevation: 60,
                        child: Container(
                          width: 320,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TabBarView(
                            children: <Widget>[
                              SignIn(),
                              SignUp(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 30, left: 30),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 70,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "images/f.png",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 30),
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "images/g.png",
                                ),
                              ),
                            ),
                            Container(
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  "images/t.png",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
