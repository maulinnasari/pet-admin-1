import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/widget_background.dart';
import 'package:intl/intl.dart';

class AddPetShop extends StatefulWidget {
  final bool isEdit;
  final String documentId;
  final String name;
  final String location;
  final int rating;
  final double lat;
  final double long;

  AddPetShop({
    @required this.isEdit,
    this.documentId = '',
    this.name = '',
    this.location = '',
    this.rating = 0,
    this.lat = 0,
    this.long = 0,
  });

  @override
  _AddPetShopState createState() => _AddPetShopState();
}

class _AddPetShopState extends State<AddPetShop> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerRating = TextEditingController();
  final TextEditingController controllerLat = TextEditingController();
  final TextEditingController controllerLong = TextEditingController();

  double widthScreen;
  double heightScreen;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      controllerName.text = widget.name;
      controllerLocation.text = widget.location;
      //controllerRating.text = widget.rating;
      //controllerLat.text = widget.lat;
      //controllerLong.text = widget.long;
    } //else {
    //controllerDate.text = DateFormat('dd MMMM yyyy').format(date);
//}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    widthScreen = mediaQueryData.size.width;
    heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            Container(
              width: widthScreen,
              height: heightScreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildWidgetFormPrimary(),
                  SizedBox(height: 16.0),
                  _buildWidgetFormSecondary(),
                  isLoading
                      ? Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  appColor.colorTertiary),
                            ),
                          ),
                        )
                      : _buildWidgetButtonAddShop(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            widget.isEdit ? 'Edit Shop' : 'Create New Shop',
            style: Theme.of(context).textTheme.display1.merge(
                  TextStyle(color: Colors.grey[800]),
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              labelText: 'Pet Shop',
            ),
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetFormSecondary() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: controllerLocation,
              decoration: InputDecoration(
                labelText: 'Location',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: controllerLat,
              decoration: InputDecoration(
                labelText: 'Lat',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: controllerLong,
              decoration: InputDecoration(
                labelText: 'Long',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: controllerRating,
              decoration: InputDecoration(
                labelText: 'Rating',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetButtonAddShop() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: RaisedButton(
        color: appColor.colorTertiary,
        child: Text(widget.isEdit ? 'UPDATE SHOP' : 'CREATE SHOP'),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () async {
          String name = controllerName.text;
          String location = controllerLocation.text;
          double lat = double.parse(controllerLat.text);
          double long = double.parse(controllerLong.text);
          int rating = int.parse(controllerRating.text);
          if (name.isEmpty) {
            _showSnackBarMessage('Name is required');
            return;
          } else if (location.isEmpty) {
            _showSnackBarMessage('Location is required');
            return;
          }
          setState(() => isLoading = true);
          if (widget.isEdit) {
            DocumentReference documentShop =
                firestore.doc('Petshop List/${widget.documentId}');
            firestore.runTransaction((transaction) async {
              DocumentSnapshot shop = await transaction.get(documentShop);
              if (shop.exists) {
                await transaction.update(
                  documentShop,
                  <String, dynamic>{
                    'name': name,
                    'location': location,
                    'rating': rating,
                    'long': long,
                    'lat': lat,
                    'image': "10",
                  },
                );
                Navigator.pop(context, true);
              }
            });
          } else {
            CollectionReference shops = firestore.collection('Petshop List');
            DocumentReference result = await shops.add(<String, dynamic>{
              'name': name,
              'location': location,
              'rating': rating,
              'long': long,
              'lat': lat,
              'image': "10",
            });
            if (result.id != null) {
              Navigator.pop(context, true);
            }
          }
        },
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
