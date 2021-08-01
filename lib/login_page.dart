import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/auth_services.dart';
import 'package:flutterfirebaseauth/petmaster_page.dart';
import 'package:flutterfirebaseauth/petshop_page.dart';
import 'package:flutterfirebaseauth/profile_page.dart';
import 'package:flutterfirebaseauth/register_page.dart';
import 'package:flutterfirebaseauth/social_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfirebaseauth/admin_page.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: HexColor("#8dcad2"),
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.only(right: 16, left: 16, top: 40),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "assets/icons/logo.png",
                          width: 190,
                          height: 190,
                        ),
                      ],
                    ),
                    Text(
                      'Login Here',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          letterSpacing: 5),
                    ),
                    SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Password',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _passController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              fillColor: Colors.white,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  SignInSignUpResult result =
                                      await AuthServices.signInWithEmail(
                                    email: _emailController.text,
                                    pass: _passController.text,
                                  );

                                  var firebaseUser =
                                      await FirebaseAuth.instance.currentUser;

                                  if (result.user != null) {
                                    await getUserRole(firebaseUser.uid, result);
                                  } else {
                                    // Show Dialog
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Error'),
                                        content: Text(result.message),
                                        actions: <Widget>[
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              color: Color(0xFF4f4f4f),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          'OR',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocalIcon(
                          iconSrc: "assets/icons/google-plus.svg",
                          press: () async {
                            SignInSignUpResult result =
                                await AuthServices.signInWithGoogle();
                            if (result.user != null) {
                              // Go to Profile Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                    user: result.user,
                                  ),
                                ),
                              );
                            } else {
                              // Show Dialog
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Error'),
                                  content: Text(result.message),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ]),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Don\'t have account ?',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterPage()));
                          },
                          child: Text(
                            'Register here',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getUserRole(String uid, result) async {
    String _userRole;

    FirebaseFirestore.instance.collection('Users Roles').doc(uid).get().then(
      (value) {
        var res = value.data();
        _userRole = res['Role'];
        if (_userRole == 'Admin') {
          // Go to Profile Page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(
                user: result.user,
              ),
            ),
          );
        } else if (_userRole == 'PetMaster') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetMasterPage(
                user: result.user,
              ),
            ),
          );
        } else if (_userRole == 'PetShop') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PetShopPage(
                user: result.user,
                email_shop: res["Email"],
                id_shop: res["ID"],
                nik_shop: res["NIK"],
              ),
            ),
          );
        } else {
          // Show Dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(result.message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
