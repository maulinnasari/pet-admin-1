import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/makanan_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/mainan_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/aksesoris_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/grooming_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/kandang_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/vaksin_update.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/pgrooming_update.dart';
import 'package:hexcolor/hexcolor.dart';

class petshopupdate extends StatefulWidget {
  final User user;
  final String id_shop;

  petshopupdate({
    @required this.user,
    this.id_shop,
  });

  @override
  _petshopupdateState createState() => _petshopupdateState();
}

class _petshopupdateState extends State<petshopupdate> {
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
                          width: 100,
                          height: 100,
                        ),
                      ],
                    ),
                    Text(
                      'Hello!',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 36,
                          letterSpacing: 5),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            child: RaisedButton(
                              onPressed: () async {
                                //navigate
                              },
                              child: Text(
                                'Update Pet Shop',
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
                          'Update Facilities',
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return AksesorisUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Aksesoris',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return GroomingUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Grooming',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return CageUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Kandang',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FoodUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Makanan & Vitamin',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ToyUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Mainan',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return VaksinUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Vaksinasi',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PGroomingUpdatePetShop(
                                  user: widget.user,
                                  id_shop: widget.id_shop,
                                );
                              }));
                            },
                            child: Text(
                              'Produk Grooming',
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            color: HexColor("#54797E"),
                            elevation: 0,
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
