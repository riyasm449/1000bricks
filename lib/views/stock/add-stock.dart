import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/models/suppliers.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddStock extends StatefulWidget {
  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  TextEditingController amount = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController subCategory = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController totalAmount = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedSite;
  String selectedSupplier;
  String selectedCategory = 'Cement';
  Sites sites;
  Suppliers suppliers;
  bool isLoading = false;
  List<String> sitesName = [];
  List<String> suppliersName = [];
  List<String> categoriesList = [
    'Cement',
    'Electrical\'s',
    'JCB',
    'Old Balance',
    'Others',
    'Plumbing',
    'Raw Materials',
    'Steel'
  ];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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

  void getAllSuppliers() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'thousandBricksApi/getSupplierDetails.php?type=all',
      );
      setState(() {
        suppliers = Suppliers.fromJson(jsonDecode(responce.data));
        if (suppliers.data != null) {
          for (int i = 0; i < suppliers.data.length; i++) {
            suppliersName.add(suppliers.data[i].companyName);
          }
          if (suppliersName.isNotEmpty) selectedSupplier = suppliersName[0];
        }
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

  String getSupplierId() {
    int index;
    for (int i = 0; i < suppliers.data.length; i++) {
      if (suppliers.data[i].companyName == selectedSupplier) {
        index = i;
        break;
      }
    }
    return suppliers.data[index].id;
  }

  addStock() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'siteId': getSiteId(),
      'date': selectedDate.toString(),
      'supplierId': getSupplierId(),
      'amount': amount.text != '' ? amount.text : '0',
      'category': selectedCategory,
      'subCategory': subCategory.text,
      'comment': comment.text,
      'quantity': quantity.text != '' ? quantity.text : '0',
      'totalAmount': totalAmount.text
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('thousandBricksApi/addNewStock.php', data: data);
      Commons.snackBar(scaffoldKey, 'Added Stock');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Provider.of<ManagementProvider>(context, listen: false).getAllStock();
      Navigator.pop(context);
      clear();
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing Some Problem');
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  clear() {
    comment.clear();
    subCategory.clear();
    amount.text = '0';
    totalAmount.text = '0';
    quantity.text = '0';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  bool valid() {
    return selectedSite != null &&
        selectedDate != null &&
        selectedCategory != null &&
        selectedSupplier != null &&
        amount.text != '' &&
        amount.text != '0' &&
        quantity.text != '' &&
        quantity.text != '0' &&
        totalAmount.text != '' &&
        totalAmount.text != '0';
  }

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSuppliers());
    quantity.text = '1';
    amount.text = '0';
    totalAmount.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Stock', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
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
                        // if (widget.income == null)
                        setState(() {
                          selectedSite = value;
                        });
                      },
                      value: selectedSite,
                      title: 'Select Site *'),
                  dateCard(),
                  // if (suppliersName != null)
                  dropDownBox(
                      list: suppliersName,
                      onChange: (String value) {
                        // if (widget.income == null)
                        setState(() {
                          selectedSupplier = value;
                        });
                      },
                      value: selectedSupplier,
                      title: 'Select Supplier *'),
                  dropDownBox(
                      list: categoriesList,
                      onChange: (String value) {
                        // if (widget.income == null)
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                      value: selectedCategory,
                      title: 'Select Category *'),
                  textWidget(title: 'SubCategory', controller: subCategory),
                  numberField(
                      title: 'Amount *',
                      controller: amount,
                      onChange: (String value) {
                        if (value != '' && value != '0' && quantity.text != '' && quantity.text != '0') {
                          totalAmount.text = '${int.parse(value) * int.parse(quantity.text)}';
                          print('${int.parse(value) * int.parse(quantity.text)}');
                        } else {
                          print('0');
                          totalAmount.text = '0';
                        }
                      }),
                  numberField(
                      title: 'Quantity *',
                      controller: quantity,
                      onChange: (String value) {
                        if (value != '' && value != '0' && amount.text != '' && amount.text != '0') {
                          totalAmount.text = '${int.parse(value) * int.parse(amount.text)}';
                          print('${int.parse(value) * int.parse(amount.text)}');
                        } else {
                          print('0');
                          totalAmount.text = '0';
                        }
                      }),
                  numberField(title: 'Total Amount', controller: totalAmount),
                  textWidget(title: 'Comment', controller: comment),
                  // if (widget.income == null)
                  FlatButton(
                    color: Commons.bgColor,
                    onPressed: () {
                      if (valid()) {
                        addStock();
                      } else {
                        Commons.snackBar(
                            scaffoldKey, 'Fill all the fields with * || amount or quantity or total should not be 0');
                      }
                    },
                    child: Text('  ADD  ', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
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

  Widget dateCard() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text('Date:  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: dateController,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(top: 0.0)),
                      )))
            ])));
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
      Function(String) onChange,
      bool enabled = true,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: enabled,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          onChanged: onChange,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
