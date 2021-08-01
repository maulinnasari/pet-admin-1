import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirebaseauth/petshop_facilities_update/edit_kandang.dart';
import 'package:flutterfirebaseauth/widget_background.dart';
import 'package:flutterfirebaseauth/app_color.dart';

class CageUpdatePetShop extends StatefulWidget {
  final User user;
  final String id_shop;

  CageUpdatePetShop({
    @required this.user,
    this.id_shop,
  });

  @override
  _CageUpdatePetShopState createState() => _CageUpdatePetShopState();
}

class _CageUpdatePetShopState extends State<CageUpdatePetShop> {
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AppColor appColor = AppColor();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double widthScreen = mediaQueryData.size.width;
    double heightScreen = mediaQueryData.size.height;

    return Scaffold(
      key: scaffoldState,
      backgroundColor: appColor.colorPrimary,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            WidgetBackground(),
            _buildWidgetListTodo(widthScreen, heightScreen, context),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () async {
                bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CageEdit(
                              user: widget.user,
                              isEdit: false,
                              id_shop: widget.id_shop,
                            )));
                if (result != null && result) {
                  scaffoldState.currentState.showSnackBar(SnackBar(
                    content: Text('Cage Has Been Added'),
                  ));
                  setState(() {});
                }
              },
              heroTag: null,
              backgroundColor: appColor.colorTertiary,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildWidgetListTodo(
      double widthScreen, double heightScreen, BuildContext context) {
    return Container(
      width: widthScreen,
      height: heightScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 25.0),
            child: Text(
              'UPDATE KANDANG',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('Produk & Service')
                  .doc(widget.id_shop)
                  .collection('Kandang')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data.docs[index];
                    Map<String, dynamic> shop = document.data();
                    // String strRate = shop['rating'].toString();
                    return Card(
                      child: ListTile(
                        title: Text('\n' + shop['item']),
                        subtitle: Text(
                          'Rp. ' +
                              shop['harga'].toString() +
                              '\n\n' +
                              shop['desc'].toString() +
                              '\n',
                          maxLines: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: false,
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: appColor.colorSecondary,
                                shape: BoxShape.circle,
                              ),
                              //child: Center(
                              //child: Text(
                              // '${int.parse(strRate.split(' ')[0])}',
                              // style: TextStyle(color: Colors.white),
                              //),
                              //),
                            ),
                            SizedBox(height: 4.0),
                            //Text(
                            //  strRate.split(' ')[1],
                            //  style: TextStyle(fontSize: 12.0),
                            //),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (BuildContext context) {
                            return List<PopupMenuEntry<String>>()
                              ..add(PopupMenuItem<String>(
                                value: 'edit',
                                child: Text('Edit'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'edit') {
                              bool result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return CageEdit(
                                    id_cage: document.reference.id,
                                    name: shop['item'],
                                    price: shop['harga'].toString(),
                                    desc: shop['desc'],
                                    user: widget.user,
                                    isEdit: true,
                                    id_shop: widget.id_shop,
                                  );
                                }),
                              );
                              if (result != null && result) {
                                scaffoldState.currentState
                                    .showSnackBar(SnackBar(
                                  content: Text('Cage Has Been updated'),
                                ));
                                setState(() {});
                              }
                            } else if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Are You Sure'),
                                    content: Text(
                                        'Do you want to delete ${shop['name']}?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Delete'),
                                        onPressed: () {
                                          document.reference.delete();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
