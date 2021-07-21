import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool showStock = false;
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
          list = snapshot.data.docs.map((doc) {
            return doc['dateTime'];
          }).toList();
          return Stack(
            children: [
              // Icon(Icons.notifications_outlined),
              Image.network(
                "https://img.icons8.com/color/144/000000/appointment-reminders--v3.png",
                width: 30,
              ),
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
        // backgroundColor: Commons.colorFromHex('#EFEFEF'),
        drawer: Drawer(
          child: SingleChildScrollView(
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
                              Navigator.pushNamed(context, '/add-site');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_business_outlined, size: 20),
                                Text(' Add site', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showSite)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/site');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.home_outlined, size: 20),
                                Text(' Site Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
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
                              Navigator.pushNamed(context, '/add-supplier');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_shopping_cart_outlined, size: 20),
                                Text('Add supplier', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showSupplier)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/supplier');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.shopping_cart_outlined, size: 20),
                                Text(' Supplier Management',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
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
                              Navigator.pushNamed(context, '/add-meeting');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.group_add_outlined, size: 20),
                                Text(' Add meeting', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showMeeting)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/meeting');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.group_outlined, size: 20),
                                Text(' Meetings', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
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
                              Navigator.pushNamed(context, '/add-income');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_chart, size: 20),
                                Text(' Add Income', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showIncome)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/income');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.input_rounded, size: 20),
                                Text(' Income Management', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
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
                              Navigator.pushNamed(context, '/add-expence');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_chart, size: 20),
                                Text(' Add General Expense',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showExpence)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/expence');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.input_rounded, size: 20),
                                Text(' Expense Management',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      showStock = !showStock;
                    });
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Stock Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Icon(!showStock ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                        ],
                      ),
                      if (showStock)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/add-stock');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_shopping_cart_outlined, size: 20),
                                Text(' Add Stock', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showStock)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/stock');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.storage, size: 20),
                                Text(' Master Inventory', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      showStock = !showStock;
                    });
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Catalogue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Icon(!showStock ? Icons.arrow_drop_down : Icons.arrow_drop_up),
                        ],
                      ),
                      if (showStock)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/add-images');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 20),
                                Text(' Add Catalogue', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                      if (showStock)
                        ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, '/stock');
                            },
                            title: Row(
                              children: [
                                Icon(Icons.storage, size: 20),
                                Text(' Master Inventory', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                              ],
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thousand Bricks', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              InkWell(
                  onTap: () {
                    dashboardProvider.getDashboardData();
                  },
                  child: Icon(Icons.refresh)),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/money');
                  },
                  child: Image.network(
                    "https://img.icons8.com/color/96/000000/rupee--v1.png",
                    width: 30,
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/meeting');
                  },
                  child: notificationIcon()),
              InkWell(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await Navigator.pushReplacementNamed(context, '/login');
                },
                child: Icon(Icons.logout_outlined),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text('DASHBOARD ', style: TextStyle(color: Commons.bgColor, fontSize: 24, fontWeight: FontWeight.bold)),
                Image.network(
                  "https://img.icons8.com/material-outlined/96/000000/dashboard-layout.png",
                  width: 30,
                ),
              ],
            ),
          ),
          if (dashboardProvider.isLoading)
            Padding(
              padding: const EdgeInsets.all(25),
              child: CircularProgressIndicator(),
            ),
          if (dashboardProvider.dashboardData != null && !dashboardProvider.isLoading)
            Column(
              children: [
                card('Total Sites', dashboardProvider.dashboardData?.siteCount, dir: '/site'),
                card('Total Suppliers', dashboardProvider.dashboardData?.totalSuppliers, dir: '/supplier'),
              ],
            ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Text('UPCOMING MEETINGS ',
                    style: TextStyle(color: Commons.bgColor, fontSize: 20, fontWeight: FontWeight.bold)),
                Image.network(
                  "https://img.icons8.com/dotty/80/000000/meeting-room.png",
                  width: 30,
                ),
              ],
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection("meeting")
                  .where("dateTime", isGreaterThan: DateTime.now().toString())
                  .snapshots(),
              builder: (context, snapshot) {
                List list = [];
                if (snapshot.hasData) {
                  List<TableRow> list = snapshot.data.docs.map((doc) {
                    return TableRow(children: [
                      tableTitle(doc['dateTime'].toString().substring(0, 10)),
                      tableTitle(doc['description']),
                      tableTitle(doc['location']),
                      tableTitle(doc['type']),
                    ]);
                  }).toList();
                  return list.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(15),
                          child: Table(
                            border: TableBorder.all(),
                            children: [
                              TableRow(children: [
                                tableTitle('Date', bold: true),
                                tableTitle('Description', bold: true),
                                tableTitle('Location', bold: true),
                                tableTitle('Mode', bold: true),
                              ]),
                              for (int i = 0; i < list.length; i++) list[i]
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            Image.network(
                              "https://img.icons8.com/dotty/80/000000/meeting-room.png",
                              width: 180,
                            ),
                            Text('No Upcoming Meetings')
                          ],
                        );
                } else {
                  return Column(
                    children: [
                      Image.network(
                        "https://img.icons8.com/dotty/80/000000/meeting-room.png",
                        width: 180,
                      ),
                      Text('No Upcoming Meetings')
                    ],
                  );
                }
              })
        ])));
  }

  Widget tableTitle(String title, {Color textColor, bool bold = false, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      constraints: BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.w400, color: textColor ?? Commons.bgColor)),
    );
  }

  Widget card(String title, String value, {String dir}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, dir);
        },
        child: Card(
          color: Colors.white,
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
      ),
    );
  }
}
