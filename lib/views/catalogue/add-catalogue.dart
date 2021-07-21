import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:thousandbricks/models/income.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddCatalogue extends StatefulWidget {
  final IncomeData income;

  const AddCatalogue({Key key, this.income}) : super(key: key);
  @override
  _AddCatalogueState createState() => _AddCatalogueState();
}

class _AddCatalogueState extends State<AddCatalogue> {
  String selectedSite;
  Sites sites;
  String progress;
  bool isLoading = false;
  List<String> sitesName = [];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  List<File> files = [];

  void getAllSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getSiteDetails.php?type=all',
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

  String getSiteId() {
    int index;
    for (int i = 0; i < sites.data.length; i++) {
      if (sites.data[i].siteName == selectedSite) {
        index = i;
        break;
      }
    }
    return sites.data[index].id;
  }

  addIncome() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  selectFiles() async {
    List<File> _files = await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'jpeg'],
    );
    setState(() {
      files.addAll(_files);
    });
  }

  Future<bool> uploadFile(List<File> file) async {
    setState(() {
      isLoading = true;
    });
    List filesData = [];
    try {
      for (int i = 0; i < file.length; i++) {
        var res = FirebaseStorage.instance.ref(basename(file[i].path));
        await res.putFile(file[i]).then((value) async {
          String link = await value.ref.getDownloadURL();
          setState(() {
            progress = "${i + 1} - ${file.length} Estimation files uploading";
          });
          filesData.add(link);
          print(link);
        });
      }
      FirebaseFirestore.instance
          .collection('catalogue')
          .doc('${getSiteId()}')
          .set({'images': FieldValue.arrayUnion(filesData)});
      setState(() {
        isLoading = false;
      });
      Commons.snackBar(scaffoldKey, 'Files Added');
      return true;
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      Commons.snackBar(scaffoldKey, 'Some problem in Adding Files');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Catalogue', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  dropDownBox(
                      list: sitesName,
                      onChange: (String value) {
                        if (widget.income == null)
                          setState(() {
                            selectedSite = value;
                          });
                      },
                      value: selectedSite,
                      title: 'Select Site *'),
                  filePicker(
                    context,
                    title: 'Add Images [png,jpg,gif]*',
                    file: files,
                    selectFile: () {
                      selectFiles();
                    },
                    remove: (int value) {
                      setState(() {
                        files.removeAt(value);
                      });
                    },
                  ),
                  FlatButton(
                    color: Commons.bgColor,
                    onPressed: () {
                      if (files.isNotEmpty) {
                        uploadFile(files);
                      }
                    },
                    child: Text('ADD IMAGES', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
    );
  }

  Widget filePicker(BuildContext context,
      {@required String title, @required List<File> file, selectFile(), Function(int) remove}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
      child: Column(
        children: [
          Row(children: [
            Text('$title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Container(
                child: RaisedButton.icon(
                    onPressed: () {
                      selectFile();
                    },
                    icon: Icon(Icons.folder_open),
                    label: Text("CHOOSE FILE"),
                    color: Colors.redAccent,
                    colorBrightness: Brightness.dark))
          ]),
          if (file.isNotEmpty)
            for (int i = 0; i < file.length; i++)
              Row(children: [
                Container(
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width - 82,
                    child: Text(basename(file[i].path))),
                InkWell(
                    onTap: () {
                      remove(i);
                    },
                    child: Icon(Icons.cancel_sharp))
              ]),
        ],
      ),
    );
  }

  Widget dropDownBox(
      {@required List<String> list, @required Function(String) onChange, @required value, @required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            underline: Container(height: 0),
            onChanged: onChange,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        )
      ]),
    );
  }

  Widget numberField(
      {@required String title,
      @required TextEditingController controller,
      num maxLength,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: widget.income == null,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
