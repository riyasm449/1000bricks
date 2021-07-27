import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/site-details.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class SiteDetailsPage extends StatefulWidget {
  final String id;
  final bool edit;
  const SiteDetailsPage({Key key, @required this.id, this.edit = false}) : super(key: key);
  @override
  _SiteDetailsPageState createState() => _SiteDetailsPageState();
}

class _SiteDetailsPageState extends State<SiteDetailsPage> {
  bool isLoading = false;
  bool isDownLoading = false;
  String progress;
  SiteDetails siteDetails;
  String siteName;
  String siteLocation;
  String clientName;
  String clientBillingAddress;
  String clientGst;
  String contactMailId;
  String mobileNumber;
  String categoryOfWork;
  String projectStartedOn;
  String estimatedCompletionOfProject;
  String statusOfProject;
  List estimationAndBoqFile;
  List threeDRendersFile;
  List drawingsFile;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Directory dir;
  List<String> categoryList = [
    'Architectural Design',
    'Landscaping Design',
    'Interiors',
    'Construction',
    'HVAC',
    'Project Management'
  ];
  List<String> statusList = [
    'In Pipeline',
    'In Design Process',
    'Site Execution in Progress',
    'Project Completed',
    'Project on Hold',
    'Project Terminated'
  ];

  List<File> estimation = [];
  List<File> renders = [];
  List<File> drawings = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSiteDetails());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dir = await getApplicationDocumentsDirectory();
    });
  }

  selectEstimationFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      estimation.addAll(files);
    });
    uploadFile('estimation', estimation).then((value) {
      setState(() {
        estimation = [];
      });
    });
  }

  selectRenderFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      renders.addAll(files);
    });
    uploadFile('render', renders).then((value) {
      setState(() {
        renders = [];
      });
    });
  }

  selectDrawingFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      drawings.addAll(files);
    });
    uploadFile('drawing', drawings).then((value) {
      setState(() {
        drawings = [];
      });
    });
  }

  Future<bool> uploadFile(String category, List<File> file) async {
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
          .collection('files')
          .doc('${widget.id}')
          .update({category: FieldValue.arrayUnion(filesData)});
      setState(() {
        isLoading = false;
      });
      getSiteDetails();
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

  void getSiteDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getSiteDetails.php?type=${widget.id}',
      );
      var res = await FirebaseFirestore.instance.collection('files').doc('${widget.id}').get();
      print(responce);
      setState(() {
        siteDetails = SiteDetails.fromJson(jsonDecode(responce.data));
        if (siteDetails != null) {
          siteName = siteDetails.data[0].siteName;
          siteLocation = siteDetails.data[0].siteLocation;
          clientName = siteDetails.data[0].clientName;
          clientBillingAddress = siteDetails.data[0].clientBillingAddress;
          clientGst = siteDetails.data[0].clientGst;
          contactMailId = siteDetails.data[0].contactMailId;
          mobileNumber = siteDetails.data[0].mobileNumber;
          categoryOfWork = siteDetails.data[0].categoryOfWork;
          projectStartedOn = siteDetails.data[0].projectStartedOn;
          estimatedCompletionOfProject = siteDetails.data[0].estimatedCompletionOfProject;
          statusOfProject = siteDetails.data[0].statusOfProject;
          estimationAndBoqFile = res.data()['estimation'];
          threeDRendersFile = res.data()['render'];
          drawingsFile = res.data()['drawing'];
        }
      });
      print(responce);
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  editData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'id': widget.id,
      'siteName': siteName,
      'siteLocation': siteLocation,
      'clientName': clientName,
      'clientBillingAddress': clientBillingAddress,
      'clientGst': clientGst,
      'contactMailId': contactMailId,
      'mobileNumber': '+91' + mobileNumber,
      'categoryOfWork': categoryOfWork,
      'projectStartedOn': projectStartedOn,
      'estimatedCompletionOfProject': estimatedCompletionOfProject,
      'statusOfProject': statusOfProject,
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post(
          'http://1000bricks.meatmatestore.in/thousandBricksApi/updateSiteDetails.php?type=updateTextData',
          data: data, onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " + percentage + " % uploaded";
        });
      });
      Commons.snackBar(scaffoldKey, 'Updated Site Details Successfully');
      getSiteDetails();
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Provider.of<ManagementProvider>(context, listen: false).getAllSites();
      Navigator.pop(context);
      print(responce);
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently facing some Issue');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Site Details', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Column(children: [
              Center(child: Padding(padding: const EdgeInsets.all(25), child: CircularProgressIndicator())),
              if (progress != null) Text(progress)
            ])
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (siteDetails != null)
                    if (siteDetails.data != null)
                      if (siteDetails.data.isNotEmpty)
                        Column(
                          children: [
                            textWidget(
                                title: 'Site Name',
                                controller: siteName,
                                onChange: (String value) {
                                  setState(() => siteName = value);
                                }),
                            textWidget(
                                title: 'Site Location',
                                controller: siteLocation,
                                onChange: (String value) {
                                  setState(() => siteLocation = value);
                                }),
                            textWidget(
                                title: 'Client Name',
                                controller: clientName,
                                onChange: (String value) {
                                  setState(() => clientName = value);
                                }),
                            textWidget(
                                title: 'Client Billing Address',
                                controller: clientBillingAddress,
                                minLine: 5,
                                maxLine: 8,
                                padding: const EdgeInsets.all(10),
                                onChange: (String value) {
                                  setState(() => clientBillingAddress = value);
                                }),
                            numberField(
                                title: 'Phone Number',
                                controller: mobileNumber,
                                onChange: (String value) {
                                  setState(() => mobileNumber = value);
                                }),
                            textWidget(
                                title: 'Mail Id',
                                controller: contactMailId,
                                onChange: (String value) {
                                  setState(() => contactMailId = value);
                                }),
                            dropDownBox(
                                list: categoryList,
                                value: categoryOfWork != '' && categoryList.contains(categoryOfWork)
                                    ? categoryOfWork
                                    : null,
                                onChange: (String value) => setState(() => categoryOfWork = value),
                                title: 'Category of work'),
                            dropDownBox(
                                list: statusList,
                                onChange: (String value) => setState(() => statusOfProject = value),
                                value: statusOfProject != '' ? statusOfProject : null,
                                title: 'Status Of Project'),
                            textWidget(
                                title: 'Client GST',
                                controller: clientGst,
                                onChange: (String value) {
                                  setState(() => clientGst = value);
                                }),
                            if (widget.edit)
                              FlatButton(
                                  color: Commons.bgColor,
                                  onPressed: () {
                                    editData(context);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            if (isDownLoading)
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: CircularProgressIndicator(),
                                  ),
                                  Text(progress ?? '', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
                                ],
                              )
                            else
                              Column(
                                children: [
                                  /// estimation
                                  if (estimationAndBoqFile != null)
                                    if (estimationAndBoqFile.isNotEmpty)
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          child: Text('Estimation and BOQ Files',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                  if (estimationAndBoqFile != null)
                                    if (estimationAndBoqFile.isNotEmpty)
                                      gridCard(<Widget>[
                                        for (int i = 0; i < estimationAndBoqFile.length; i++)
                                          gridItem(estimationAndBoqFile[i])
                                      ]),

                                  /// 3d renders
                                  if (threeDRendersFile != null)
                                    if (threeDRendersFile.isNotEmpty)
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          child: Text('3D Render Files',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                  if (threeDRendersFile != null)
                                    if (threeDRendersFile.isNotEmpty)
                                      gridCard(<Widget>[
                                        for (int i = 0; i < threeDRendersFile.length; i++)
                                          gridItem(threeDRendersFile[i])
                                      ]),

                                  /// drawings
                                  if (drawingsFile != null)
                                    if (drawingsFile.isNotEmpty)
                                      Container(
                                          width: MediaQuery.of(context).size.width,
                                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                          child: Text('Estimation and BOQ Files',
                                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                                  if (drawingsFile != null)
                                    if (drawingsFile.isNotEmpty)
                                      gridCard(<Widget>[
                                        for (int i = 0; i < drawingsFile.length; i++) gridItem(drawingsFile[i])
                                      ]),
                                ],
                              ),
                            if (widget.edit)
                              Column(
                                children: [
                                  estimationField(context),
                                  renderField(context),
                                  drawingsField(context),
                                ],
                              ),
                          ],
                        )
                ],
              ),
            ),
    );
  }

  Widget renderField(BuildContext context) {
    return filePicker(
      context,
      title: '3D Renders',
      file: renders,
      selectFile: () {
        selectRenderFile();
      },
      remove: (int value) {
        setState(() {
          renders.removeAt(value);
        });
      },
    );
  }

  Widget drawingsField(BuildContext context) {
    return filePicker(
      context,
      title: 'Drawings',
      file: drawings,
      selectFile: () {
        selectDrawingFile();
      },
      remove: (int value) {
        setState(() {
          drawings.removeAt(value);
        });
      },
    );
  }

  Widget estimationField(BuildContext context) {
    return filePicker(
      context,
      title: 'Estimation & BOQ',
      file: estimation,
      selectFile: () {
        selectEstimationFile();
      },
      remove: (int value) {
        setState(() {
          estimation.removeAt(value);
        });
      },
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
            Text('$title: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
          // if (file.isNotEmpty)
          //   for (int i = 0; i < file.length; i++)
          //     Row(children: [
          //       Container(
          //           margin: EdgeInsets.all(5),
          //           width: MediaQuery.of(context).size.width - 82,
          //           child: Text(basename(file[i].path))),
          //       InkWell(
          //           onTap: () {
          //             remove(i);
          //           },
          //           child: Icon(Icons.cancel_sharp))
          //     ]),
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

  Widget gridItem(String url) {
    Dio _dio = Dio();

    String path = "${dir.path}/${getFileName(url)}";
    bool isFileExists = File(path).existsSync();
    return InkWell(
      onTap: () async {
        if (!isDownLoading) {
          setState(() {
            isDownLoading = true;
          });
          try {
            if (!isFileExists) {
              print('true');
              await _dio.download(url, path, onReceiveProgress: (rec, total) {
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
            isDownLoading = false;
          });
          print(url);
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: !isFileExists ? Colors.blueGrey.withOpacity(.6) : Colors.grey.withOpacity(.6),
                borderRadius: BorderRadius.circular(8)),
          ),
          Text(getFileType(url) + ' file', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Positioned(
            top: 10,
            right: 5,
            left: 5,
            child: !isFileExists
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 15,
                      ),
                      Text('Download', style: TextStyle(color: Colors.white, fontSize: 9)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 15,
                      ),
                      Text('View', style: TextStyle(color: Colors.white, fontSize: 9)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget gridCard(List<Widget> list) {
    return GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 3,
        children: list ?? []);
  }

  String getFileName(String data) {
    List<String> url = data.split("/");
    List<String> name = url[url.length - 1].split("?");
    print(name[0]);
    return name[0];
  }

  String getFileType(String data) {
    List<String> url = data.split(".");
    List<String> name = url[url.length - 1].split("?");
    print(name[0]);
    return name[0];
  }

  Widget textWidget(
      {@required String title,
      @required String controller,
      num minLine,
      num maxLine,
      Function(String) onChange,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: controller ?? '',
          minLines: minLine,
          maxLines: maxLine,
          onChanged: onChange,
          enabled: widget.edit,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }

  Widget numberField(
      {@required String title,
      @required String controller,
      num maxLength,
      Function(String) onChange,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: controller,
          keyboardType: TextInputType.number,
          enabled: widget.edit,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          onChanged: onChange,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
