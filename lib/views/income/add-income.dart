import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/income.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddIncomePage extends StatefulWidget {
  final IncomeData income;

  const AddIncomePage({Key key, this.income}) : super(key: key);
  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  TextEditingController amount = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedSite;
  String selectedPaymentType = 'Cash';
  Sites sites;
  bool isLoading = false;
  List<String> sitesName = [];
  List<String> paymentTypes = ['Cash', 'Cheque', 'Online'];

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

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

  addIncome() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'site': selectedSite,
      'date': selectedDate.toString(),
      'amount': amount.text,
      'modeOfPayment': selectedPaymentType,
      'comment': comment.text
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce =
          await dio.post('http://1000bricks.meatmatestore.in/thousandBricksApi/addNewIncome.php', data: data);
      Commons.snackBar(scaffoldKey, 'Added Income');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
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
    amount.clear();
    selectedDate = null;
    selectedPaymentType = null;
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

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
    if (widget.income != null) {
      dateController.text = DateFormat.yMd().format(DateTime.parse(widget.income.date));
      amount.text = widget.income.amount;
      selectedSite = widget.income.site;
      selectedPaymentType = widget.income.modeOfPayment;
      comment.text = widget.income.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(),
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
                      title: 'Select Site'),
                  dateCard(),
                  textWidget(title: 'Comment', controller: comment),
                  numberField(title: 'Amount', controller: amount),
                  dropDownBox(
                      list: paymentTypes,
                      onChange: (String value) {
                        if (widget.income == null)
                          setState(() {
                            selectedPaymentType = value;
                          });
                      },
                      value: selectedPaymentType,
                      title: 'Select Payment Mode'),
                  if (widget.income == null)
                    FlatButton(
                      color: Commons.bgColor,
                      onPressed: () {
                        addIncome();
                      },
                      child: Text('ADD INCOME', style: TextStyle(color: Colors.white)),
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
          enabled: widget.income == null,
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
                  child: Text('Date of Income:  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
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
