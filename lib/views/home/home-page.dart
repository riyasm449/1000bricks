import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/userProvider.dart';
import 'package:thousandbricks/utils/commons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    // var samp = _firebaseMessaging.getToken();
    // print(samp);
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     final notification = message['notification'];
    //     print(notification);
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //
    //     final notification = message['data'];
    //     print(notification);
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //   },
    // );
    // if (Platform.isMacOS)
    //   _firebaseMessaging
    //       .requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  color: Commons.bgColor,
                  alignment: Alignment.bottomLeft,
                  child: Text(userProvider.user?.name ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              SizedBox(height: 15),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/site');
                },
                title: Text('Site Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/supplier');
                },
                title: Text('Supplier Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thousand Bricks', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              Icon(Icons.home),
              Icon(Icons.notifications_outlined),
              Icon(Icons.chat_outlined),
              Icon(Icons.call_outlined),
              Icon(Icons.logout_outlined),
            ],
          ),
        ),
        body: Column(
          children: [],
        ));
  }
}
