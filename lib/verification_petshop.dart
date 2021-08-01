import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfirebaseauth/app_color.dart';
import 'package:flutterfirebaseauth/widget_background.dart';

class VerificationPetshop extends StatelessWidget {
  final String text;
  VerificationPetshop({Key key, @required this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Verification Petshop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColor().colorPrimary,
        ),
        home: HomeVerificationPetshop(),
        routes: <String, WidgetBuilder>{
          //'/beratIdeal': (context) => BeratIdeal()
        });
  }
}

class HomeVerificationPetshop extends StatefulWidget {
  @override
  _HomeVerificationPetshopState createState() =>
      _HomeVerificationPetshopState();
}

class _HomeVerificationPetshopState extends State<HomeVerificationPetshop> {
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
              'VERIFICATION PETSHOP',
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore
                  .collection('Petshop List')
                  .where("status", isEqualTo: false)
                  // .where("name", isNotEqualTo: "Not Registered")
                  // .orderBy('rating')
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
                    String strRate = shop['rating'].toString();
                    return Card(
                      child: ListTile(
                        title: Text(shop['name']),
                        subtitle: Text(
                          shop['location'],
                          maxLines: 1,
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
                              child: Center(
                                child: Text(
                                  '${int.parse(strRate.split(' ')[0])}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
                                value: 'verif',
                                child: Text('Verification'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'delete',
                                child: Text('Delete'),
                              ))
                              ..add(PopupMenuItem<String>(
                                value: 'view',
                                child: Text('View'),
                              ));
                          },
                          onSelected: (String value) async {
                            if (value == 'verif') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Are You Sure'),
                                    content: Text(
                                        'Do you want to verify ${shop['name']}?'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text('Verify'),
                                        onPressed: () {
                                          document.reference
                                              .update({'status': true});
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
