import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';
import 'package:thousandbricks/views/site/site-details.dart';

class SiteManagement extends StatefulWidget {
  @override
  _SiteManagementState createState() => _SiteManagementState();
}

class _SiteManagementState extends State<SiteManagement> {
  bool isLoading = false;
  String progress;
  Sites sites;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
  }

  void getAllSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getSiteDetails.php?type=all',
      );
      print(responce);
      setState(() {
        sites = Sites.fromJson(jsonDecode(responce.data));
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  // void deleteSite(String id) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   Map<String, dynamic> map = {'id': id};
  //   FormData data = FormData.fromMap(map);
  //   print(map);
  //   try {
  //     var responce = await dio.post(
  //         'http://1000bricks.meatmatestore.in/thousandBricksApi/updateSiteDetails.php?type=deleteSite',
  //         data: data);
  //     getAllSites();
  //     print(responce);
  //   } catch (e) {
  //     print('>>>>>>>>> error <<<<<<<');
  //     print(e);
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Site Management', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Table(border: TableBorder.all(), // Allows to add a border decoration around your table
                  children: [
                    TableRow(children: [
                      tableTitle('Site Name', bold: true),
                      tableTitle('Site Location', bold: true),
                      tableTitle('View', bold: true),
                      tableTitle('Edit', bold: true),
                    ]),
                    if (!isLoading && sites != null)
                      if (sites.data?.isNotEmpty)
                        for (int index = 0; index < sites.data.length; index++)
                          if (sites.data[index].statusOfProject != 'Project Terminated')
                            TableRow(children: [
                              tableTitle(sites.data[index].siteName,
                                  textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                              tableTitle(sites.data[index].siteLocation, textColor: Colors.black),
                              Center(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    SiteDetailsPage(id: sites.data[index].id)));
                                      },
                                      icon: Icon(Icons.remove_red_eye))),
                              // Container(
                              //     height: 50,
                              //     alignment: Alignment.center,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //       children: [
                              Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SiteDetailsPage(id: sites.data[index].id, edit: true)));
                                    },
                                    icon: Icon(Icons.edit)),
                              ),
                              // InkWell(
                              //     onTap: () async {
                              //       // deleteSite(sites.data[index].id);
                              //     },
                              //     child: Icon(Icons.delete)),
                              //   ],
                              // ))
                            ]),
                  ]),
            ),
          ],
        ),
      ),
    );
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
}
