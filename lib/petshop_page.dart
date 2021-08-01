import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/auth_services.dart';
import 'package:flutterfirebaseauth/dokter_list.dart';
import 'package:flutterfirebaseauth/login_page.dart';
import 'package:flutterfirebaseauth/petshop_registration.dart';
import 'package:flutterfirebaseauth/petshop_update.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutterfirebaseauth/petshop_page.dart';
import 'package:flutterfirebaseauth/update_petshop.dart';
import 'package:flutterfirebaseauth/reminder.dart';

class PetShopPage extends StatefulWidget {
  final User user;
  final String email_shop;
  final String id_shop;
  final String nik_shop;

  PetShopPage({
    @required this.user,
    this.email_shop,
    this.id_shop,
    this.nik_shop,
  });

  @override
  _PetShopPageState createState() => _PetShopPageState();
}

class _PetShopPageState extends State<PetShopPage> {
  @override
  Widget build(BuildContext context) {
    String a = widget.email_shop;
    String b = widget.id_shop;
    String c = widget.nik_shop;
    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(
          color: HexColor("#8dcad2"),
        ),
        child: Container(
          margin: EdgeInsets.only(right: 0, left: 0, top: 130),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(right: 16, left: 16, top: 0),
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Row(
                        children: <Widget>[
                          Text(
                            'Hello Pet Shop.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Do you have something new for me?',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            letterSpacing: 2),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              /*showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blue),
                                        ),
                                        SizedBox(width: 16.0),
                                        Text(
                                          "Please wait...",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );*/
                              bool stat;
                              FirebaseFirestore.instance
                                  .collection('Petshop List')
                                  .doc(widget.id_shop)
                                  .get()
                                  .then((value1) {
                                var res1 = value1.data();
                                stat = res1['status'];

                                if (stat == true) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Hello'),
                                        content: Text('You were registered'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return RegPetShop(
                                      usershop: widget.user,
                                      emailshop: widget.email_shop,
                                      idshop: widget.id_shop,
                                      nikshop: widget.nik_shop,
                                    );
                                  }));
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/icons/updatepetshop.jpeg',
                                  width: 100,
                                  height: 100,
                                ),
                                new Text(
                                  'Pet Shop Registration',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Widget Kedua
                          GestureDetector(
                            onTap: () {
                              bool stat;
                              FirebaseFirestore.instance
                                  .collection('Petshop List')
                                  .doc(widget.id_shop)
                                  .get()
                                  .then((value1) {
                                var res1 = value1.data();
                                stat = res1['status'];

                                if (stat == false) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Hello'),
                                        content: Text(
                                            'You are not registered\n\nPlease wait Admin to verify your account'),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text('Ok'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return petshopupdate(
                                      user: widget.user,
                                      id_shop: widget.id_shop,
                                    );
                                  }));
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/icons/fasilitas.jpeg',
                                  width: 100,
                                  height: 100,
                                ),
                                new Text(
                                  'Update Pet Facilities',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Widget Ketiga
                        ],
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DoctorList()));
                            },
                            //Widget Pertama
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  'assets/icons/doctor.jpeg',
                                  width: 90,
                                  height: 90,
                                ),
                                new Text(
                                  'Chat Dokter',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //Widget keempat
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Image.asset(
                                'assets/icons/resetuser.jpeg',
                                width: 90,
                                height: 90,
                              ),
                              new Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          //Widget Ketiga
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
                      child: Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            // sign out google
                            AuthServices.signOutGoogle();

                            // sign out
                            AuthServices.signOut();

                            // go to login page
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                                (route) => false);
                          },
                          child: Text(
                            'Log Out',
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
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
