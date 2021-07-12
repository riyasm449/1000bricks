import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/suppliers.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class SupplierDetailsPage extends StatefulWidget {
  final String id;
  final bool edit;

  const SupplierDetailsPage({Key key, this.id, this.edit = false}) : super(key: key);
  @override
  _SupplierDetailsPageState createState() => _SupplierDetailsPageState();
}

class _SupplierDetailsPageState extends State<SupplierDetailsPage> {
  String companyName;
  String contactPerson;
  String contactNumber;
  String alternateNumber;
  String GSTnumber;
  String accNumber;
  String bankName;
  String IFSC;
  String bankBranch;
  String address;
  String mail;
  Suppliers suppliers;

  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  editSupplier() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'id': widget.id,
      'companyName': companyName,
      'contactPerson': contactPerson,
      'contactNumber': contactNumber,
      'alternateContactNumber': alternateNumber,
      'eMail': mail,
      'bankAccountDetails': {'accNumber': accNumber, 'branch': bankBranch, 'name': bankName, 'ifsc': IFSC}.toString(),
      'address': address,
      'gstNumber': GSTnumber
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post(
          'http://1000bricks.meatmatestore.in/thousandBricksApi/updateSupplierDetails.php?type=deleteSupplier',
          data: data);
      setState(() {
        suppliers = Suppliers.fromJson(jsonDecode(responce.data));
      });
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Commons.snackBar(scaffoldKey, 'Added Successfully...');
      print(responce);
      clear();
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing Some Issue!!!');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  clear() {
    contactNumber = null;
    contactPerson = null;
    companyName = null;
    alternateNumber = null;
    mail = null;
    accNumber = null;
    bankName = null;
    bankBranch = null;
    IFSC = null;
    address = null;
    GSTnumber = null;
  }

  getDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      var responce = await dio
          .get('https://1000bricks.meatmatestore.in/thousandBricksApi/getSupplierDetails.php?type=${widget.id}');
      setState(() {
        suppliers = Suppliers.fromJson(jsonDecode(responce.data));
        if (suppliers?.data != null) {
          companyName = suppliers.data[0].companyName;
          contactPerson = suppliers.data[0].contactPerson;
          contactNumber = suppliers.data[0].contactNumber;
          alternateNumber = suppliers.data[0].alternateContactNumber;
          mail = suppliers.data[0].eMail;
          address = suppliers.data[0].address;
          GSTnumber = suppliers.data[0].gstNumber;
        }
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => getDetails());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Supplier', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  textWidget(title: 'Company Name', controller: companyName),
                  textWidget(title: 'Contact Person', controller: contactPerson),
                  textWidget(title: 'Contact Number', controller: contactNumber),
                  textWidget(title: 'Alternate Contact Number', controller: alternateNumber),
                  textWidget(title: 'Mail Id', controller: mail),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Text('Bank Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                    child: Column(
                      children: [
                        textWidget(title: 'Account Number', controller: accNumber),
                        textWidget(title: 'Bank Name', controller: bankName),
                        textWidget(title: 'Bank Branch', controller: bankBranch),
                        textWidget(title: 'IFSC Code', controller: IFSC),
                      ],
                    ),
                  ),
                  textWidget(
                      title: 'Billing Address',
                      controller: address,
                      minLine: 5,
                      maxLine: 8,
                      padding: const EdgeInsets.all(10)),
                  textWidget(title: 'Client GST', controller: GSTnumber),
                  if (widget.edit)
                    RaisedButton.icon(
                        onPressed: () {
                          editSupplier();
                        },
                        icon: Icon(Icons.save),
                        label: Text("ADD SUPPLIER"),
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

  Widget textWidget(
      {@required String title,
      @required String controller,
      num minLine,
      num maxLine,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          initialValue: controller,
          minLines: minLine,
          enabled: widget.edit,
          maxLines: maxLine,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }

  Widget numberField(
      {@required String title,
      @required String controller,
      num maxLength,
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
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
