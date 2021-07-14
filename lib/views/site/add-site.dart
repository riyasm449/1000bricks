import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddSite extends StatefulWidget {
  @override
  _AddSiteState createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  TextEditingController siteName = TextEditingController();
  TextEditingController siteLocation = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientBillingAddress = TextEditingController();
  TextEditingController clientGST = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String category = 'Architectural Design';
  List<File> estimation = [];
  List<File> renders = [];
  List<File> drawings = [];
  DateTime startedOn = DateTime.now();
  DateTime endedOn = DateTime.now();
  String status = 'In Pipeline';
  String progress;
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
  clear() {
    siteName.clear();
    siteLocation.clear();
    clientName.clear();
    clientGST.clear();
    clientBillingAddress.clear();
    mail.clear();
    phoneNumber.clear();
    setState(() {
      estimation = [];
      renders = [];
      drawings = [];
      progress = null;
    });
  }

  bool validate() {
    return siteName.text != '' &&
        siteLocation.text != '' &&
        clientName.text != '' &&
        clientGST.text != '' &&
        clientBillingAddress.text != '' &&
        phoneNumber.text != '';
  }

  Future<void> selectStartDate(BuildContext context) async {
    print('pressed');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: startedOn ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startedOn)
      setState(() {
        startedOn = picked;
      });
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: endedOn ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endedOn)
      setState(() {
        endedOn = picked;
      });
  }

  selectEstimationFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      estimation.addAll(files);
    });
  }

  selectRenderFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      renders.addAll(files);
    });
  }

  selectDrawingFile() async {
    List<File> files = await FilePicker.getMultiFile(
      type: FileType.custom,
    );
    setState(() {
      drawings.addAll(files);
    });
  }

  bool isLoading = false;

  addForm(BuildContext context) async {
    List estimationFiles = [];
    List renderFiles = [];
    List drawingFiles = [];
    setState(() {
      isLoading = true;
    });

    for (int i = 0; i < estimation.length; i++) {
      var res = FirebaseStorage.instance.ref(basename(estimation[i].path));
      await res.putFile(estimation[i]).then((value) async {
        String link = await value.ref.getDownloadURL();
        setState(() {
          progress = "${i + 1} - ${estimation.length} Estimation files uploading";
        });
        estimationFiles.add(link);
        print(link);
      });
    }

    for (int i = 0; i < renders.length; i++) {
      var res = FirebaseStorage.instance.ref(basename(renders[i].path));
      await res.putFile(renders[i]).then((value) async {
        String link = await value.ref.getDownloadURL();
        setState(() {
          progress = "${i + 1} - ${renders.length} Render files uploading";
        });
        renderFiles.add(link);
        print(link);
      });
    }
    for (int i = 0; i < drawings.length; i++) {
      var res = FirebaseStorage.instance.ref(basename(drawings[i].path));
      await res.putFile(drawings[i]).then((value) async {
        String link = await value.ref.getDownloadURL();
        setState(() {
          progress = "${i + 1} - ${drawings.length} Drawing files uploading";
        });
        drawingFiles.add(link);
        print(link);
      });
    }

    Map<String, dynamic> mapData = {
      'siteName': siteName.text,
      'siteLocation': siteLocation.text,
      'clientName': clientName.text,
      'clientBillingAddress': clientBillingAddress.text,
      'clientGst': clientGST.text,
      'contactMailId': mail.text,
      'mobileNumber': phoneNumber.text,
      'categoryOfWork': category,
      'estimationAndBoqLinks': estimationFiles,
      'estimationAndBoqFiles': [],
      'threeDRendersLinks': renderFiles,
      'threeDRendersFiles': [],
      'drawingsLinks': drawingFiles,
      'drawingsFiles': [],
      'projectStartedOn': startedOn.toString(),
      'estimatedCompletionOfProject': endedOn.toString(),
      'statusOfProject': status
    };
    print([estimationFiles, renderFiles]);
    FormData data = FormData.fromMap(mapData);
    print(data.files);
    try {
      var responce = await dio.post('http://1000bricks.meatmatestore.in/thousandBricksApi/addNewSite.php', data: data,
          onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          progress = percentage + " % uploaded";
        });
      });
      print(responce.data);
      var id;
      id = jsonDecode(responce.data)['id'];
      print(id);
      if (id != null) {
        await FirebaseFirestore.instance
            .collection('files')
            .doc('$id')
            .set({'estimation': estimationFiles, 'render': renderFiles, 'drawing': drawingFiles});
      }

      Commons.snackBar(scaffoldKey, 'Site Added');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      clear();
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently facing some problem');
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
        title: Text('Add Site', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Column(
              children: [
                SizedBox(height: 120),
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 15),
                if (progress != null)
                  Center(
                    child: Text(progress),
                  ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  textWidget(title: 'Site Name *', controller: siteName),
                  textWidget(title: 'Site Location *', controller: siteLocation),
                  textWidget(title: 'Client Name *', controller: clientName),
                  textWidget(
                      title: 'Client Billing Address *',
                      controller: clientBillingAddress,
                      minLine: 5,
                      maxLine: 8,
                      padding: const EdgeInsets.all(10)),
                  textWidget(title: 'Mail Id', controller: mail),
                  numberField(title: 'Phone Number *', controller: phoneNumber, maxLength: 10),
                  textWidget(title: 'Client GST *', controller: clientGST),
                  dropDownBox(
                      list: categoryList,
                      value: category,
                      onChange: (String value) => setState(() => category = value),
                      title: 'Category of work *'),
                  estimationField(context),
                  renderField(context),
                  drawingsField(context),
                  datePicker(context, title: 'Project Started on *', dateTime: startedOn, onPressed: () {
                    selectStartDate(context);
                  }),
                  datePicker(context, title: 'Estimation Completed *', dateTime: endedOn, onPressed: () {
                    selectEndDate(context);
                  }),
                  dropDownBox(
                      list: statusList,
                      onChange: (String value) => setState(() => status = value),
                      value: status,
                      title: 'Status Of Project'),
                  RaisedButton.icon(
                      onPressed: () {
                        if (validate()) {
                          addForm(context);
                        } else {
                          Commons.snackBar(scaffoldKey, 'Fill all the fields with *');
                        }
                      },
                      icon: Icon(Icons.save),
                      label: Text("ADD"),
                      color: Commons.bgColor,
                      colorBrightness: Brightness.dark)
                ],
              ),
            ),
    );
  }

  Widget datePicker(BuildContext context,
      {@required String title, @required DateTime dateTime, @required Function() onPressed}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (dateTime != null)
              Text("${dateTime.toLocal()}".split(' ')[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RaisedButton(onPressed: onPressed, child: Text('Select date'))
          ]))
    ]);
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

  Widget textWidget(
      {@required String title,
      @required TextEditingController controller,
      num minLine,
      num maxLine,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          minLines: minLine,
          maxLines: maxLine,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
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
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
