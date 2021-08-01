import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/petshop_registration.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Upload KTP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadingImageToFirebaseStorage(),
    );
  }
}

final Color yellow = Color(0xFF8dcad2);
final Color orange = Color(0xFF425195);

class UploadingImageToFirebaseStorage extends StatefulWidget {
  final User usershop;
  final String emailshop;
  final String idshop;
  final String nikshop;
  final String up_ktp;

  UploadingImageToFirebaseStorage({
    Key mykey,
    @required this.usershop,
    this.emailshop,
    this.idshop,
    this.nikshop,
    this.up_ktp,
  }) : super(key: mykey);

  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile;

  String isUpload = '';

  Future pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _imageFile = File(pickedFile.path);
      isUpload = "true";
    });
  }

  Future uploadImageToFirebase() async {
    //String fileName = path.basename(_imageFile.path);
    String fileName = widget.idshop;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference ref = firebaseStorage.ref().child('Uploads/$fileName');
    UploadTask uploadTask = ref.putFile(_imageFile);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });

    String stat = "true";

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RegPetShop(
        usershop: widget.usershop,
        emailshop: widget.emailshop,
        idshop: widget.idshop,
        nikshop: widget.nikshop,
        up_ktp: stat,
      );
    }));
    //setState(() {

    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 120),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "UPLOAD KTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontStyle: FontStyle.normal),
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white,
                          child: ClipRRect(
                            child: Align(
                              widthFactor: 200.0,
                              heightFactor: 350.0,
                              child: _imageFile != null
                                  ? Image.file(_imageFile)
                                  : Image.network(
                                      "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 300.0),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.camera,
                            size: 30.0,
                          ),
                          onPressed: () {
                            pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                uploadImageButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    if (isUpload == "true") {
      return Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              margin: const EdgeInsets.only(
                  top: 30, left: 20.0, right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [yellow, orange],
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              child: FlatButton(
                onPressed: () {
                  uploadImageToFirebase();
                },
                child: Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
              margin: const EdgeInsets.only(
                  top: 30, left: 20.0, right: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [yellow, orange],
                  ),
                  borderRadius: BorderRadius.circular(30.0)),
              child: FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Hello'),
                        content: Text('You have not yet picked an image'),
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
                },
                child: Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
