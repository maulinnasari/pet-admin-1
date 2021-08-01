import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/widget_background.dart';
import 'package:intl/intl.dart';

class GroomingEdit extends StatefulWidget {
  final User user;
  final String id_shop;
  final bool isEdit;
  final String id_grm;
  final String name;
  final String price1;
  final String price2;
  final String desc;

  GroomingEdit({
    @required this.user,
    this.id_shop,
    this.isEdit,
    this.id_grm,
    this.name,
    this.price1,
    this.price2,
    this.desc,
  });

  @override
  _GroomingEditState createState() => _GroomingEditState();
}

class _GroomingEditState extends State<GroomingEdit> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();
  final TextEditingController controllerItem = TextEditingController();
  final TextEditingController controllerHarga1 = TextEditingController();
  final TextEditingController controllerHarga2 = TextEditingController();
  final TextEditingController controllerDesc = TextEditingController();

  double widthScreen;
  double heightScreen;
  bool isLoading = false;

  @override
  void initState() {
    if (widget.isEdit) {
      controllerItem.text = widget.name;
      controllerHarga1.text = widget.price1;
      controllerHarga2.text = widget.price2;
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
            widget.isEdit ? 'Edit Grooming' : 'Tambah Grooming',
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
              controller: controllerHarga1,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga 1',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: controllerHarga2,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Harga 2',
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
              ),
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
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
          int price1 = int.parse(controllerHarga1.text);
          int price2 = int.parse(controllerHarga2.text);
          String desc = controllerDesc.text;
          if (name.isEmpty) {
            _showSnackBarMessage('Name is required');
            return;
          } else if (price1.toString().isEmpty) {
            _showSnackBarMessage('Harga 1 is required');
            return;
          } else if (price2.toString().isEmpty) {
            _showSnackBarMessage('Harga 2 is required');
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
                .collection('Grooming')
                .doc(widget.id_grm);
            firestore.runTransaction((transaction) async {
              DocumentSnapshot shop = await transaction.get(documentTask);
              if (shop.exists) {
                await transaction.update(
                  documentTask,
                  <String, dynamic>{
                    'item': name,
                    'harga1': price1,
                    'harga2': price2,
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
                .collection('Grooming');
            DocumentReference result = await tasks.add(<String, dynamic>{
              'item': name,
              'harga1': price1,
              'harga2': price2,
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
