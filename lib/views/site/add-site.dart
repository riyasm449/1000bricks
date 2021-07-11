import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddSite extends StatefulWidget {
  @override
  _AddSiteState createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  TextEditingController siteName = TextEditingController();
  TextEditingController siteLocation = TextEditingController();
  TextEditingController clientName = TextEditingController();
  TextEditingController clientBillingAddress = TextEditingController();
  TextEditingController clientGST = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  String category;
  List<File> estimation = [];
  List<File> renders = [];
  List<File> drawings = [];
  DateTime startedOn;
  DateTime endedOn;
  String status;
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
      category = null;
      estimation = [];
      renders = [];
      drawings = [];
      startedOn = null;
      progress = null;
    });
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

  addForm() async {
    List estimationFiles = [];
    List renderFiles = [];
    List drawingFiles = [];
    setState(() {
      isLoading = true;
    });
    for (int i = 0; i < estimation.length; i++) {
      var value = await MultipartFile.fromFile(estimation[i].path, filename: basename(estimation[i].path));
      estimationFiles.add(value);
    }

    for (int i = 0; i < renders.length; i++) {
      var value = await MultipartFile.fromFile(renders[i].path, filename: basename(renders[i].path));
      renderFiles.add(value);
    }
    for (int i = 0; i < drawings.length; i++) {
      var value = await MultipartFile.fromFile(drawings[i].path, filename: basename(drawings[i].path));
      drawingFiles.add(value);
    }
    print([estimationFiles, renderFiles, drawingFiles]);

    ///todo phone Number
    Map<String, dynamic> mapData = {
      'siteName': siteName.text,
      'siteLocation': siteLocation.text,
      'clientName': clientName.text,
      'clientBillingAddress': clientBillingAddress.text,
      'clientGst': clientGST.text,
      'contactMailId': mail.text,
      'mobileNumber': '+91' + phoneNumber.text,
      'categoryOfWork': category,
      'estimationAndBoqLinks': [],
      'estimationAndBoqFiles': estimationFiles,
      'threeDRendersLinks': [],
      'threeDRendersFiles': renderFiles,
      'drawingsLinks': [],
      'drawingsFiles': drawingFiles,
      'projectStartedOn': startedOn.toString(),
      'estimatedCompletionOfProject': endedOn.toString(),
      'statusOfProject': status
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('http://1000bricks.meatmatestore.in/thousandBricksApi/addNewSite.php', data: data,
          onSendProgress: (int sent, int total) {
        String percentage = (sent / total * 100).toStringAsFixed(2);
        setState(() {
          progress = "$sent" + " Bytes of " "$total Bytes - " + percentage + " % uploaded";
          //update the progress
        });
        clear();
      });
      print(responce);
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Site', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Column(
              children: [
                if (progress != null)
                  Center(
                    child: Text(progress),
                  ),
                Center(child: CircularProgressIndicator()),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  textWidget(title: 'Site Name', controller: siteName),
                  textWidget(title: 'Site Location', controller: siteLocation),
                  textWidget(title: 'Client Name', controller: clientName),
                  textWidget(
                      title: 'Client Billing Address',
                      controller: clientBillingAddress,
                      minLine: 5,
                      maxLine: 8,
                      padding: const EdgeInsets.all(10)),
                  textWidget(title: 'Mail Id', controller: mail),
                  numberField(title: 'Phone Number', controller: phoneNumber, maxLength: 10),
                  textWidget(title: 'Client GST', controller: clientGST),
                  dropDownBox(
                      list: categoryList,
                      value: category,
                      onChange: (String value) => setState(() => category = value),
                      title: 'Category of work'),
                  estimationField(context),
                  renderField(context),
                  drawingsField(context),
                  datePicker(context, title: 'Project Started on', dateTime: startedOn, onPressed: () {
                    selectStartDate(context);
                  }),
                  datePicker(context, title: 'Estimation Completed', dateTime: endedOn, onPressed: () {
                    selectEndDate(context);
                  }),
                  dropDownBox(
                      list: statusList,
                      onChange: (String value) => setState(() => status = value),
                      value: status,
                      title: 'Status Of Project'),
                  RaisedButton.icon(
                      onPressed: () {
                        addForm();
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
      {@required String title, @required DateTime dateTime, @required Function onPressed()}) {
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
      // widget: TextFormField(
      //   controller: sample2,
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(),
      //       hintText: 'Add Links',
      //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
      //       suffix: IconButton(
      //         onPressed: () {
      //           if (sample2.text != '')
      //             setState(() {
      //               if (!rendersLinks.contains(sample2.text)) {
      //                 rendersLinks.add(sample2.text);
      //                 sample2.clear();
      //               }
      //             });
      //         },
      //         icon: Icon(Icons.add_circle_rounded),
      //       )),
      // ),
      // links: rendersLinks,
      // removeLink: (int value) {
      //   setState(() {
      //     rendersLinks.removeAt(value);
      //   });
      // },
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
      // widget: TextFormField(
      //   controller: sample3,
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(),
      //       hintText: 'Add Links',
      //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
      //       suffix: IconButton(
      //         onPressed: () {
      //           if (sample3.text != '')
      //             setState(() {
      //               if (!drawingsLinks.contains(sample3.text)) {
      //                 drawingsLinks.add(sample3.text);
      //                 sample3.clear();
      //               }
      //             });
      //         },
      //         icon: Icon(Icons.add_circle_rounded),
      //       )),
      // ),
      // links: drawingsLinks,
      // removeLink: (int value) {
      //   setState(() {
      //     drawingsLinks.removeAt(value);
      //   });
      // },
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
      // widget: TextFormField(
      //   controller: sample1,
      //   decoration: InputDecoration(
      //       border: OutlineInputBorder(),
      //       hintText: 'Add Links',
      //       contentPadding: EdgeInsets.symmetric(horizontal: 10),
      //       suffix: IconButton(
      //         onPressed: () {
      //           if (sample1.text != '')
      //             setState(() {
      //               if (!estimationLinks.contains(sample1.text)) {
      //                 estimationLinks.add(sample1.text);
      //                 sample1.clear();
      //               }
      //             });
      //           print(estimationLinks);
      //         },
      //         icon: Icon(Icons.add_circle_rounded),
      //       )),
      // ),
      // links: estimationLinks,
      // removeLink: (int value) {
      //   setState(() {
      //     estimationLinks.removeAt(value);
      //   });
      // },
    );
  }

  Widget filePicker(
    BuildContext context, {
    @required String title,
    @required List<File> file,
    selectFile(),
    Function(int) remove,
    // Function(int) removeLink,
    // Widget widget,
    // List<String> links
  }) {
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
          // if (widget != null) widget,
          // if (links != null)
          //   if (links.isNotEmpty)
          //     for (int i = 0; i < links.length; i++)
          //       Row(children: [
          //         Container(
          //             margin: EdgeInsets.all(5), width: MediaQuery.of(context).size.width - 82, child: Text(links[i])),
          //         InkWell(
          //             onTap: () {
          //               removeLink(i);
          //             },
          //             child: Icon(Icons.cancel_sharp))
          //       ]),
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
