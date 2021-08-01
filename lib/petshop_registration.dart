import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/UploadImage.dart';
import 'package:flutterfirebaseauth/main.dart';
import 'package:flutterfirebaseauth/widget_background.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class RegPetShop extends StatefulWidget {
  final User usershop;
  final String emailshop;
  final String idshop;
  final String nikshop;
  final String up_ktp;

  RegPetShop({
    Key mykey,
    @required this.usershop,
    this.emailshop,
    this.idshop,
    this.nikshop,
    this.up_ktp,
  }) : super(key: mykey);

  @override
  _RegPetShopState createState() => _RegPetShopState();
}

class _RegPetShopState extends State<RegPetShop> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();
  final TextEditingController controllerRating = TextEditingController();
  final TextEditingController controllerLat = TextEditingController();
  final TextEditingController controllerLong = TextEditingController();

  double widthScreen;
  double heightScreen;
  bool isLoading = false;
  var locationMessage = '';
  String latitude;
  String longitude;

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;
    final coordinates = Coordinates(lat, long);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    // passing this to latitude and longitude strings
    latitude = "$lat";
    longitude = "$long";

    setState(() {
      controllerLat.text = latitude;
      controllerLong.text = longitude;
      controllerLocation.text = addresses.first.subAdminArea;
    });
  }

  @override
  Widget build(BuildContext context) {
    String email = widget.emailshop;
    String uid = widget.idshop;
    String nik = widget.nikshop;

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
                  SizedBox(height: 10.0),
                  SizedBox(height: 10.0),
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
                      : Container(
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: RaisedButton(
                            color: appColor.colorTertiary,
                            child: Text("Submit"),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            onPressed: () async {
                              String name = controllerName.text;
                              String location = controllerLocation.text;
                              double lat = double.parse(controllerLat.text);
                              double long = double.parse(controllerLong.text);
                              //int rating = int.parse(controllerRating.text);
                              if (name.isEmpty) {
                                _showSnackBarMessage('Name is required');
                                return;
                              } else if (location.isEmpty) {
                                _showSnackBarMessage('Location is required');
                                return;
                              }
                              setState(() => isLoading = true);

                              String role = "", email = "", id = "", nik = "";
                              FirebaseFirestore.instance
                                  .collection('Users Roles')
                                  .doc(widget.idshop)
                                  .get()
                                  .then(
                                (value) {
                                  var res = value.data();
                                  role = res['Role'];
                                  email = res['Email'];
                                  id = res['ID'];
                                  nik = res['NIK'];

                                  if (email == widget.emailshop &&
                                      id == widget.idshop &&
                                      nik == widget.nikshop) {
                                    //last
                                    DocumentReference documentShop = _firestore
                                        .doc('Petshop List/${widget.idshop}');
                                    _firestore
                                        .runTransaction((transaction) async {
                                      DocumentSnapshot shop =
                                          await transaction.get(documentShop);
                                      if (shop.exists) {
                                        await transaction.update(
                                          documentShop,
                                          <String, dynamic>{
                                            'name': name,
                                            'location': location,
                                            'rating': 0,
                                            'long': long,
                                            'lat': lat,
                                            'image': "10",
                                            'status': false,
                                            'email': widget.emailshop,
                                            'id': widget.idshop,
                                            'nik': widget.nikshop,
                                          },
                                        );
                                        Navigator.pop(context, true);
                                      } else {
                                        _showSnackBarMessage('Not found');
                                      }
                                    });
                                  }
                                },
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetFormPrimary() {
    if (widget.up_ktp == "true") {
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
            SizedBox(height: 10.0),
            Text(
              "Pet Shop Registration",
              style: Theme.of(context).textTheme.display1.merge(
                    TextStyle(color: Colors.grey[800]),
                  ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                labelText: 'Pet Shop Name',
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                RaisedButton(
                  color: appColor.colorTertiary,
                  child: Text(
                    'Upload KTP',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadingImageToFirebaseStorage(
                                  usershop: widget.usershop,
                                  emailshop: widget.emailshop,
                                  idshop: widget.idshop,
                                  nikshop: widget.nikshop,
                                  up_ktp: widget.nikshop,
                                )));
                  },
                ),
                Text(
                  '     Uploaded',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
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
            SizedBox(height: 10.0),
            Text(
              "Pet Shop Registration",
              style: Theme.of(context).textTheme.display1.merge(
                    TextStyle(color: Colors.grey[800]),
                  ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: controllerName,
              decoration: InputDecoration(
                labelText: 'Pet Shop Name',
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                RaisedButton(
                  color: appColor.colorTertiary,
                  child: Text(
                    'Upload KTP',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UploadingImageToFirebaseStorage(
                                  usershop: widget.usershop,
                                  emailshop: widget.emailshop,
                                  idshop: widget.idshop,
                                  nikshop: widget.nikshop,
                                  up_ktp: widget.nikshop,
                                )));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: .0),
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
            SizedBox(height: 5.0),
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
            SizedBox(height: 5.0),
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
            SizedBox(height: 5.0),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 82.0, vertical: 5.0),
              child: RaisedButton(
                color: appColor.colorSecondary,
                child: Text("Set Current Location"),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  getCurrentLocation();
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                getCurrentLocation();
              },
              child: Text(
                'Pick Location',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBarMessage(String message) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

//testing code
//new
                              /*var a = await FirebaseFirestore.instance
                                  .collection("Petshop List")
                                  .doc(widget.idshop)
                                  .get();
                              if (a.exists) {
                                final DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection("Petshop List")
                                        .doc(widget.idshop);
                                return await documentReference.update({
                                  //your data
                                  'name': name,
                                  'location': location,
                                  'rating': 0,
                                  'long': long,
                                  'lat': lat,
                                  'image': "10",
                                  'status': false,
                                  'email': widget.emailshop,
                                  'id': widget.idshop,
                                  'nik': widget.nikshop,
                                });
                                Navigator.pop(context, true);
                              } else {
                                final DocumentReference documentReference =
                                    FirebaseFirestore.instance
                                        .collection("Petshop List")
                                        .doc(name);
                                return await documentReference.set({
                                  //your data
                                  'name': name,
                                  'location': location,
                                  'rating': 0,
                                  'long': long,
                                  'lat': lat,
                                  'image': "10",
                                  'status': false,
                                  'email': widget.emailshop,
                                  'id': widget.idshop,
                                  'nik': widget.nikshop,
                                });
                                Navigator.pop(context, true);
                              }
                              */
                              //new
