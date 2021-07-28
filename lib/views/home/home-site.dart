import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thousandbricks/models/site-details.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class HomeSite extends StatefulWidget {
  final String number;

  const HomeSite({Key key, this.number = '49'}) : super(key: key);
  @override
  _HomeSiteState createState() => _HomeSiteState();
}

class _HomeSiteState extends State<HomeSite> {
  bool isLoading = false;
  SitesData siteDetails;
  String totalSiteIncome;
  String totalSiteExpense;
  List images = [];
  String progress;
  Directory dir;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  void getSiteDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      print(widget.number);
      var responce = await dio.post('thousandBricksApi/getSiteIncomeExpenseDetails.php',
          data: FormData.fromMap({'mobileNumber': widget.number}));
      if (responce != null) siteDetails = SitesData.fromJson(jsonDecode(responce.data)["siteDetails"][0]);
      if (responce != null)
        setState(() {
          totalSiteExpense = jsonDecode(responce.data)["totalSiteExpense"] ?? '0';
          totalSiteIncome = jsonDecode(responce.data)["totalSiteIncome"] ?? '0';
        });
      print('>>>>>>${siteDetails.id}');
    } catch (e) {
      print('>>>>>><<<<<<<<<<<<<<<<<<');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSiteDetails());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dir = await getApplicationDocumentsDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Thousand Bricks', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            Row(children: [
              InkWell(
                  onTap: () {
                    getSiteDetails();
                  },
                  child: Icon(Icons.refresh)),
              SizedBox(width: 15),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.logout_outlined))
            ])
          ],
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    child: Row(children: [
                      Text('DASHBOARD ',
                          style: TextStyle(color: Commons.bgColor, fontSize: 22, fontWeight: FontWeight.bold)),
                      Image.network(
                        "https://img.icons8.com/material-outlined/96/000000/dashboard-layout.png",
                        width: 30,
                      )
                    ])),
                card('Total Income', totalSiteIncome),
                card('Total Expense', totalSiteExpense),
              ],
            )),
    );
  }

  Widget gallary() {
    try {
      return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("catalogue").doc(siteDetails.id).snapshots(),
          builder: (context, snapshot) {
            List list = [];
            if (snapshot.hasError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/empty.png",
                      width: 180,
                    ),
                  ),
                  Text('No Upcoming Meetings')
                ],
              );
            } else if (snapshot.hasData) {
              list = snapshot.data['images'] ?? [];
              return list.isNotEmpty
                  ? Column(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15),
                            child: Row(children: [
                              Text('SITE GALLERY ',
                                  style: TextStyle(color: Commons.bgColor, fontSize: 22, fontWeight: FontWeight.bold)),
                              Image.network(
                                "https://img.icons8.com/material-outlined/96/000000/dashboard-layout.png",
                                width: 30,
                              )
                            ])),
                        if (list != null) gridCard(list)
                      ],
                    )
                  : Commons.placholder();
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/empty.png",
                      width: 180,
                    ),
                  ),
                  Text('No Upcoming Meetings')
                ],
              );
            }
          });
    } catch (e) {
      return Container();
    }
  }

  Widget card(String title, String value, {String dir}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          if (dir != null) Navigator.pushNamed(context, dir);
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

  String getFileName(String data) {
    List<String> url = data.split("/");
    List<String> name = url[url.length - 1].split("?");
    print(name[0]);
    return name[0];
  }

  Widget gridItem(String url) {
    String path = "${dir.path}/${getFileName(url)}";
    bool isFileExists = File(path).existsSync();
    return InkWell(
      onTap: () async {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          try {
            if (!isFileExists) {
              print('true');
              await dio.download(url, path, onReceiveProgress: (rec, total) {
                print("Rec: $rec , Total: $total");

                setState(() {
                  progress = ((rec / total) * 100).toStringAsFixed(0) + "% Downloaded";
                });
              });
              await OpenFile.open(path);
            } else {
              await OpenFile.open(path);
            }
          } catch (e) {
            print(e);
          }
          setState(() {
            isLoading = false;
            progress = null;
          });
          print(url);
        }
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
              border: Border.all(width: .5),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          if (!isFileExists)
            Positioned(
              top: 10,
              right: 20,
              child: Icon(
                Icons.download,
                color: Colors.black,
                size: 15,
              ),
            )
        ],
      ),
    );
  }

  Widget gridCard(List catalogue) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        childAspectRatio: 2 / 2.5,
        children: [
          for (int index = 0; index < catalogue?.length; index++)
            // Image.network(cat.catalogue[index].toString())
            gridItem(catalogue[index].toString())
        ]);
  }
}
