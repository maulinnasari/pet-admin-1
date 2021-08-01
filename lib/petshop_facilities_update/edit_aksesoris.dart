import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/widget_background.dart';
import 'package:intl/intl.dart';

class AksesorisEdit extends StatefulWidget {
  final User user;
  final String id_shop;
  final bool isEdit;
  final String id_Aks;
  final String name;
  final String price;
  final String desc;

  AksesorisEdit({
    @required this.user,
    this.id_shop,
    this.isEdit,
    this.id_Aks,
    this.name,
    this.price,
    this.desc,
  });

  @override
  _AksesorisEditState createState() => _AksesorisEditState();
}

class _AksesorisEditState extends State<AksesorisEdit> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerItem = TextEditingController();
  final TextEditingController controllerHarga = TextEditingController();
  final TextEditingController controllerDesc = TextEditingController();

  double widthScreen;
  double heightScreen;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      controllerItem.text = widget.name;
      controllerHarga.text = widget.price;
      controllerDesc.text = widget.desc;
    }
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
            widget.isEdit ? 'Edit Aksesoris' : 'Tambah Aksesoris',
            style: Theme.of(context).textTheme.display1.merge(
                  TextStyle(color: Colors.grey[800]),
                ),
          ),
          SizedBox(height: 16.0),
          TextField(
            controller: controllerItem,
            decoration: InputDecoration(
              labelText: 'Nama Item',
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
              controller: controllerHarga,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: controllerDesc,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
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
        child: Text(widget.isEdit ? 'EDIT' : 'TAMBAH'),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        onPressed: () async {
          String name = controllerItem.text;
          int price = int.parse(controllerHarga.text);
          String desc = controllerDesc.text;
          if (name.isEmpty) {
            _showSnackBarMessage('Name is required');
            return;
          } else if (price.toString().isEmpty) {
            _showSnackBarMessage('Description is required');
            return;
          } else if (desc.isEmpty) {
            _showSnackBarMessage('Description is required');
            return;
          }
          setState(() => isLoading = true);
          if (widget.isEdit) {
            //code for update begin
            DocumentReference documentTask = firestore
                .doc('Produk & Service/${widget.id_shop}')
                .collection('Aksesoris')
                .doc(widget.id_Aks);
            firestore.runTransaction((transaction) async {
              DocumentSnapshot shop = await transaction.get(documentTask);
              if (shop.exists) {
                await transaction.update(
                  documentTask,
                  <String, dynamic>{
                    'item': name,
                    'harga': price,
                    'desc': desc,
                  },
                );
                Navigator.pop(context, true);
              }
            });
          }
          //code for update end
          else {
            CollectionReference tasks = firestore
                .collection('Produk & Service')
                .doc(widget.id_shop)
                .collection('Aksesoris');
            DocumentReference result = await tasks.add(<String, dynamic>{
              'item': name,
              'harga': price,
              'desc': desc,
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
