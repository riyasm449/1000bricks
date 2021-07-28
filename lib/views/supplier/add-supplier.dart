import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/suppliers.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  TextEditingController companyName = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController GSTnumber = TextEditingController();
  TextEditingController accNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController IFSC = TextEditingController();
  TextEditingController bankBranch = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mail = TextEditingController();
  Suppliers suppliers;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool isLoading = false;

  addSupplier() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'companyName': companyName.text,
      'contactPerson': contactPerson.text,
      'contactNumber': contactNumber.text,
      'alternateContactNumber': alternateNumber.text,
      'eMail': mail.text,
      'accountNumber': accNumber.text,
      'bankBranch': bankBranch.text,
      'bankName': bankName.text,
      'ifscCode': IFSC.text,
      'address': address.text,
      'gstNumber': GSTnumber.text
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('thousandBricksApi/addNewSupplier.php', data: data);
      setState(() {
        suppliers = Suppliers.fromJson(jsonDecode(responce.data));
      });
      Commons.snackBar(scaffoldKey, 'Added Successfully...');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Provider.of<ManagementProvider>(context, listen: false).getAllSuppliers();
      Navigator.pop(context);
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
    contactNumber.clear();
    contactPerson.clear();
    companyName.clear();
    alternateNumber.clear();
    mail.clear();
    accNumber.clear();
    bankName.clear();
    bankBranch.clear();
    IFSC.clear();
    address.clear();
    GSTnumber.clear();
  }

  bool valid() {
    return companyName.text != '' &&
        contactPerson.text != '' &&
        contactNumber.text != '' &&
        accNumber.text != '' &&
        bankName.text != '' &&
        bankBranch.text != '' &&
        IFSC.text != '' &&
        address.text != '' &&
        GSTnumber.text != '';
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
                  textWidget(title: 'Company Name *', controller: companyName),
                  textWidget(title: 'Contact Person *', controller: contactPerson),
                  numberField(title: 'Contact Number *', controller: contactNumber, maxLength: 10),
                  numberField(title: 'Alternate Contact Number', controller: alternateNumber, maxLength: 10),
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
                        textWidget(title: 'Account Number *', controller: accNumber),
                        textWidget(title: 'Bank Name *', controller: bankName),
                        textWidget(title: 'Bank Branch *', controller: bankBranch),
                        textWidget(title: 'IFSC Code *', controller: IFSC),
                      ],
                    ),
                  ),
                  textWidget(
                      title: 'Billing Address *',
                      controller: address,
                      minLine: 5,
                      maxLine: 8,
                      padding: const EdgeInsets.all(10)),
                  textWidget(title: 'Client GST *', controller: GSTnumber),
                  RaisedButton.icon(
                      onPressed: () {
                        if (valid()) {
                          addSupplier();
                        } else
                          Commons.snackBar(scaffoldKey, 'Fill all the fields with *');
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
          // enabled: !widget.showDatails,
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
          // enabled: !widget.showDatails,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
