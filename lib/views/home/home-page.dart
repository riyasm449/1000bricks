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
  bool showSite = false;
  bool showSupplier = false;
  bool showMeeting = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
                  setState(() {
                    showSite = !showSite;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Site Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(!showSite ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                      ],
                    ),
                    if (showSite)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/site');
                          },
                          title: Text('Site Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    if (showSite)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/add-site');
                          },
                          title: Text('Add site', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    showSupplier = !showSupplier;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Supplier Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(!showSupplier ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                      ],
                    ),
                    if (showSupplier)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/supplier');
                          },
                          title:
                              Text('Supplier Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    if (showSupplier)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/add-supplier');
                          },
                          title: Text('Add supplier', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    showMeeting = !showMeeting;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Schedule Meeting', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(!showMeeting ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                      ],
                    ),
                    if (showMeeting)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/supplier');
                          },
                          title: Text('Meetings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    if (showMeeting)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/add-meeting');
                          },
                          title: Text('Add meeting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  ],
                ),
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
