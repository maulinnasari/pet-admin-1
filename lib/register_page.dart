import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/auth_services.dart';
import 'package:flutterfirebaseauth/login_page.dart';
import 'package:flutterfirebaseauth/profile_page.dart';
import 'package:flutterfirebaseauth/petshop_page.dart';
import 'package:hexcolor/hexcolor.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _confirmPassController = TextEditingController();
  TextEditingController _nikController = TextEditingController();

  String _role;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                    Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          letterSpacing: 5),
                    ),
                    SizedBox(height: 48),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Role',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              isExpanded: true,
                              hint: Text(
                                "Pilih Role",
                                style: TextStyle(color: Colors.grey),
                              ),
                              value: _role,
                              items: <String>[
                                'PetMaster',
                                'PetShop',
                              ].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _role = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Email',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Email tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
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
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
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
                            'NIK',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _nikController,
                            keyboardType: TextInputType.number,
                            // obscureText: true,

                            validator: (val) {
                              if (val.isEmpty) {
                                return 'NIK tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'NIK',
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
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
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
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Password tidak boleh kosong';
                              } else {
                                return null;
                              }
                            },
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
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
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
                            'Confirm Password',
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _confirmPassController,
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Confirm Password tidak boleh kosong';
                              } else if (val != _passController.text) {
                                return 'Password dan Confirm Password harus sama';
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
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
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
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
                                      await AuthServices.createUser(
                                    email: _emailController.text,
                                    pass: _passController.text,
                                  );

                                  if (result.user != null) {
                                    // Go to Profile Page
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    var uid = auth.currentUser.uid;
                                    Stream collectionStream = FirebaseFirestore
                                        .instance
                                        .collection('Users Roles')
                                        .snapshots();
                                    Stream documentStream = FirebaseFirestore
                                        .instance
                                        .collection('Users Roles')
                                        .doc(uid)
                                        .snapshots();
                                    CollectionReference users =
                                        FirebaseFirestore.instance
                                            .collection("Users Roles");
                                    users.doc(result.user.uid).set({
                                      "ID": uid,
                                      "Email": _emailController.text,
                                      "Role": _role,
                                      "NIK": _nikController.text,
                                    });

                                    if (_role == "PetMaster") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                            user: result.user,
                                          ),
                                        ),
                                      );
                                    } else {
                                      Stream collectionStream =
                                          FirebaseFirestore.instance
                                              .collection('Petshop List')
                                              .snapshots();
                                      Stream documentStream = FirebaseFirestore
                                          .instance
                                          .collection('Petshop List')
                                          .doc(uid)
                                          .snapshots();
                                      CollectionReference users =
                                          FirebaseFirestore.instance
                                              .collection("Petshop List");
                                      users.doc(result.user.uid).set({
                                        "image": "10",
                                        "status": false,
                                        "location": "",
                                        "name": "Not Registered",
                                        "long": 0,
                                        "lat": 0,
                                        "rating": 0,
                                        "id": result.user.uid,
                                        "email": _emailController.text,
                                        "nik": _nikController.text,
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PetShopPage(
                                            user: result.user,
                                          ),
                                        ),
                                      );
                                    }
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
                                'Register',
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
                          'Already have account ?',
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: Text(
                            'Login here',
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
}
