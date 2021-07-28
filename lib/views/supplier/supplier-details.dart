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
import 'package:thousandbricks/views/supplier/pay-supplier.dart';

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
  String stock;
  String income;

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
      'accountNumber': accNumber,
      'bankBranch': bankBranch,
      'bankName': bankName,
      'ifscCode': IFSC,
      'address': address,
      'gstNumber': GSTnumber
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('thousandBricksApi/updateSupplierDetails.php?type=update', data: data);
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Commons.snackBar(scaffoldKey, 'Added Successfully...');
      Provider.of<ManagementProvider>(context, listen: false).getAllSuppliers();
      Navigator.pop(context);
      print('Added Successfully...');
      print(responce);
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing Some Issue!!!');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteSupplier() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {'id': widget.id};
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('thousandBricksApi/updateSupplierDetails.php?type=deleteSupplier', data: data);
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
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
      var responce = await dio.get('thousandBricksApi/getSupplierDetails.php?type=${widget.id}');
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
          accNumber = suppliers.data[0].accountNumber;
          bankBranch = suppliers.data[0].bankBranch;
          bankName = suppliers.data[0].bankName;
          IFSC = suppliers.data[0].ifscCode;
          stock = suppliers.data[0].stockTotalAmount;
          income = suppliers.data[0].supplierPayManagementTotalAmount;
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.id == null ? 'Add Supplier' : 'Edit Supplier',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            if (widget.edit)
              RaisedButton.icon(
                  onPressed: () {
                    editSupplier();
                  },
                  icon: Icon(Icons.delete),
                  label: Text("DELETE"),
                  color: Commons.bgColor,
                  colorBrightness: Brightness.dark),
          ],
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Stock Value : ${stock != '' ? stock ?? 0 : 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Commons.bgColor)),
                        Text('Paid : ${income != '' ? income ?? 0 : 0}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Commons.bgColor)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => SupplierPay(
                                          name: companyName,
                                          id: widget.id,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(8)),
                            child: Text('Pay Supplier',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  textWidget(
                      title: 'Company Name',
                      controller: companyName,
                      onChange: (value) {
                        setState(() {
                          companyName = value;
                        });
                      }),
                  textWidget(
                      title: 'Contact Person',
                      controller: contactPerson,
                      onChange: (value) {
                        setState(() {
                          contactPerson = value;
                        });
                      }),
                  textWidget(
                      title: 'Contact Number',
                      controller: contactNumber,
                      onChange: (value) {
                        setState(() {
                          contactNumber = value;
                        });
                      }),
                  textWidget(
                      title: 'Alternate Contact Number',
                      controller: alternateNumber,
                      onChange: (value) {
                        setState(() {
                          alternateNumber = value;
                        });
                      }),
                  textWidget(
                      title: 'Mail Id',
                      controller: mail,
                      onChange: (value) {
                        setState(() {
                          mail = value;
                        });
                      }),
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
                        textWidget(
                            title: 'Account Number',
                            controller: accNumber,
                            onChange: (value) {
                              setState(() {
                                accNumber = value;
                              });
                            }),
                        textWidget(
                            title: 'Bank Name',
                            controller: bankName,
                            onChange: (value) {
                              setState(() {
                                bankName = value;
                              });
                            }),
                        textWidget(
                            title: 'Bank Branch',
                            controller: bankBranch,
                            onChange: (value) {
                              setState(() {
                                bankBranch = value;
                              });
                            }),
                        textWidget(
                            title: 'IFSC Code',
                            controller: IFSC,
                            onChange: (value) {
                              setState(() {
                                IFSC = value;
                              });
                            }),
                      ],
                    ),
                  ),
                  textWidget(
                      title: 'Billing Address',
                      controller: address,
                      minLine: 5,
                      maxLine: 8,
                      padding: const EdgeInsets.all(10),
                      onChange: (value) {
                        setState(() {
                          address = value;
                        });
                      }),
                  textWidget(
                      title: 'Client GST',
                      controller: GSTnumber,
                      onChange: (value) {
                        setState(() {
                          GSTnumber = value;
                        });
                      }),
                  if (widget.edit)
                    RaisedButton.icon(
                        onPressed: () {
                          editSupplier();
                        },
                        icon: Icon(Icons.edit),
                        label: Text("EDIT SUPPLIER"),
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
      Function(String value) onChange,
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
          onChanged: onChange,
        ),
      ]),
    );
  }

  Widget numberField(
      {@required String title,
      @required String controller,
      num maxLength,
      Function(String value) onChange,
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
