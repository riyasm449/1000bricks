import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thousandbricks/models/suppliers.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';
import 'package:thousandbricks/views/supplier/supplier-details.dart';

class SupplierManagement extends StatefulWidget {
  @override
  _SupplierManagementState createState() => _SupplierManagementState();
}

class _SupplierManagementState extends State<SupplierManagement> {
  bool isLoading = false;
  String progress;
  Suppliers suppliers;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllSites());
  }

  void getAllSites() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getSupplierDetails.php?type=all',
      );
      print(responce);
      setState(() {
        suppliers = Suppliers.fromJson(jsonDecode(responce.data));
      });
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
        title: Text('Supplier Management',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Table(border: TableBorder.all(), // Allows to add a border decoration around your table
                  children: [
                    TableRow(children: [
                      tableTitle('Site Name', bold: true),
                      tableTitle('Site Location', bold: true),
                      tableTitle('View', bold: true),
                      tableTitle('Edit', bold: true),
                    ]),
                    if (!isLoading && suppliers != null)
                      if (suppliers.data?.isNotEmpty)
                        for (int index = 0; index < suppliers.data.length; index++)
                          TableRow(children: [
                            tableTitle(suppliers.data[index].companyName,
                                textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                            tableTitle(suppliers.data[index].address, textColor: Colors.black),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => SupplierDetailsPage(
                                                    id: suppliers.data[index].id,
                                                  )));
                                    },
                                    icon: Icon(Icons.remove_red_eye))),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => SupplierDetailsPage(
                                                    id: suppliers.data[index].id,
                                                    edit: true,
                                                  )));
                                    },
                                    icon: Icon(Icons.edit)))
                          ]),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableTitle(String title, {Color textColor, bool bold = false, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      constraints: BoxConstraints(minHeight: 40),
      alignment: Alignment.center,
      child: Text(title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13, fontWeight: bold ? FontWeight.bold : FontWeight.w400, color: textColor ?? Commons.bgColor)),
    );
  }
}
