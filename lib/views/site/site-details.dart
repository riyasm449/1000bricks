import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thousandbricks/models/site-details.dart';
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
  List<EstimationAndBoqFile> estimationAndBoqFile;
  List<ThreeDRenderFile> threeDRendersFile;
  List<DrawingFile> drawingsFile;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getSiteDetails());
  }

  void getSiteDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getSiteDetails.php?type=${widget.id}',
      );
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
          estimationAndBoqFile = siteDetails.data[0].estimationAndBoqFile;
          threeDRendersFile = siteDetails.data[0].threeDRendersFile;
          drawingsFile = siteDetails.data[0].drawingsFile;
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

  editData() async {
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
      'statusOfProject': statusOfProject
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading)
              Center(child: Padding(padding: const EdgeInsets.all(8.0), child: CircularProgressIndicator())),
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
                              editData();
                            },
                            child: Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                            )),
                      if (estimationAndBoqFile != null)
                        for (int i = 0; i < estimationAndBoqFile.length; i++)
                          Column(
                            children: [
                              Text(getFileName(estimationAndBoqFile[i].fileUrl)),
                              Text(getFileType(estimationAndBoqFile[i].fileUrl))
                            ],
                          )
                    ],
                  )
          ],
        ),
      ),
    );
  }

  String getFileName(String data) {
    List<String> url = data.split("/");
    return url[url.length - 1];
  }

  String getFileType(String data) {
    List<String> url = data.split(".");
    return url[url.length - 1];
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
