import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/userProvider.dart';
import 'package:thousandbricks/utils/commons.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  DashboardProvider dashboardProvider;
  // DashboardData dashboardData;
  UserProvider userProvider;
  bool showSite = false;
  bool showSupplier = false;
  bool showMeeting = false;
  bool showIncome = false;
  bool showExpence = false;
  // bool isLoading = false;
  @override
  void initState() {
    super.initState();
    dashboardProvider = Provider.of<DashboardProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => dashboardProvider.getDashboardData());
  }

  Widget notificationIcon() {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreInstance
          .collection("meeting")
          .where("dateTime", isGreaterThan: DateTime.now().toString())
          .snapshots(),
      builder: (context, snapshot) {
        List list = [];
        if (snapshot.hasData) {
          list = snapshot.data.documents.map((doc) {
            return doc['dateTime'];
          }).toList();
          return Stack(
            children: [
              Icon(Icons.notifications_outlined),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${list.length}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              )
            ],
          );
        } else {
          return Stack(
            children: [
              Icon(Icons.notifications_outlined),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${list.length}',
                    style: TextStyle(fontSize: 6),
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    dashboardProvider = Provider.of<DashboardProvider>(context);
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
                            Navigator.pushNamed(context, '/meeting');
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
              ListTile(
                onTap: () {
                  setState(() {
                    showIncome = !showIncome;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Income Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(!showIncome ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                      ],
                    ),
                    if (showIncome)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/income');
                          },
                          title:
                              Text('Income Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    if (showIncome)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/add-income');
                          },
                          title: Text('Add Income', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    showExpence = !showExpence;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('General Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Icon(!showExpence ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                      ],
                    ),
                    if (showExpence)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/expence');
                          },
                          title:
                              Text('Expense Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                    if (showExpence)
                      ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/add-expence');
                          },
                          title:
                              Text('Add General Expense', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
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
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/meeting');
                  },
                  child: notificationIcon()),
              Icon(Icons.chat_outlined),
              Icon(Icons.call_outlined),
              Icon(Icons.logout_outlined),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              child: Text('DASHBOARD',
                  style: TextStyle(color: Commons.bgColor, fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            if (dashboardProvider.dashboardData != null)
              Column(
                children: [
                  card('Total Income', dashboardProvider.dashboardData?.totalIncome),
                  card('General Expense', dashboardProvider.dashboardData?.totalExpenses),
                  card('Available', dashboardProvider.dashboardData?.availableAmount.toString()),
                  card('Total Sites', dashboardProvider.dashboardData?.siteCount),
                  card('Total Suppliers', dashboardProvider.dashboardData?.totalSuppliers),
                ],
              ),
          ],
        ));
  }

  Widget card(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(value ?? '',
                    style: TextStyle(color: Commons.bgColor, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
