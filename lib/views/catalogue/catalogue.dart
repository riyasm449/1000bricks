import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class Catalogue extends StatefulWidget {
  @override
  _CatalogueState createState() => _CatalogueState();
}

class _CatalogueState extends State<Catalogue> {
  String selectedSite;
  Sites sites;
  String progress;
  bool isLoading = false;
  List<String> sitesName = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Directory dir;

  void getAllSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'thousandBricksApi/getSiteDetails.php?type=all',
      );
      setState(() {
        sites = Sites.fromJson(jsonDecode(responce.data));
        if (sites.data != null) {
          for (int i = 0; i < sites.data.length; i++) {
            sitesName.add(sites.data[i].siteName);
          }
        }
        if (sitesName.isNotEmpty) selectedSite = sitesName[0];
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  String getSiteName(String id) {
    String name;
    for (int i = 0; i < sites.data.length; i++) {
      if (sites.data[i].id == id) {
        name = sites.data[i].siteName;
        break;
      }
    }
    return name ?? '';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dir = await getApplicationDocumentsDirectory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: AppBar(
          title:
              Text('Add Catalogue', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Center(child: SingleChildScrollView()), Text(progress ?? '')],
              )
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("catalogue").snapshots(),
                builder: (context, snapshot) {
                  List<Cat> list = [];
                  if (snapshot.hasData) {
                    list = snapshot.data.docs.map((doc) {
                      print([doc.id, doc['images']]);
                      return Cat(id: doc.id, catalogue: doc['images']);
                    }).toList();
                    return list.isNotEmpty
                        ? ListView(
                            children: [
                              for (int index = 0; index < list.length; index++)
                                if (list[index] != null) gridCard(list[index])
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
                }));
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

  String getFileName(String data) {
    List<String> url = data.split("/");
    List<String> name = url[url.length - 1].split("?");
    print(name[0]);
    return name[0];
  }

  Widget gridCard(Cat cat) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.withOpacity(.4),
            padding: EdgeInsets.all(10),
            child: Text(
              getSiteName(cat.id.toString()),
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            childAspectRatio: 2 / 2.5,
            children: [
              for (int index = 0; index < cat.catalogue?.length; index++)
                // Image.network(cat.catalogue[index].toString())
                gridItem(cat.catalogue[index].toString())
            ]),
      ],
    );
  }
}

class Cat {
  String id;
  List catalogue;

  Cat({this.id, this.catalogue});
}
