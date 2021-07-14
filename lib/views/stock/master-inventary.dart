import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/stock.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class MasterInventory extends StatefulWidget {
  @override
  _MasterInventoryState createState() => _MasterInventoryState();
}

class _MasterInventoryState extends State<MasterInventory> {
  bool isLoading = false;
  String progress;
  Stocks sites;
  DashboardProvider dashboardProvider;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getAllInventory());
  }

  void getAllInventory() async {
    setState(() {
      isLoading = true;
    });
    try {
      var responce = await dio.get(
        'https://1000bricks.meatmatestore.in/thousandBricksApi/getStockDetails.php?type=all',
      );
      print(responce);
      setState(() {
        sites = Stocks.fromJson(jsonDecode(responce.data));
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
    dashboardProvider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Master Inventory', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Stock Value : ${dashboardProvider.dashboardData.totalSiteExpense}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Commons.bgColor)),
                  Text('To pay : ${dashboardProvider.dashboardData.totalSiteExpense}',
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
                      Navigator.pushNamed(context, '/supplier');
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Table(border: TableBorder.all(), // Allows to add a border decoration around your table
                  children: [
                    TableRow(children: [
                      tableTitle('Supplier Name', bold: true),
                      tableTitle('Site Name', bold: true),
                      tableTitle('Category', bold: true),
                      tableTitle('Amount', bold: true),
                    ]),
                    if (!isLoading && sites != null)
                      if (sites.data != null)
                        for (int index = 0; index < sites.data.length; index++)
                          TableRow(children: [
                            tableTitle(sites.data[index]?.supplierName ?? '', textColor: Colors.black),
                            tableTitle(sites.data[index]?.siteName ?? '', textColor: Colors.black),
                            tableTitle(sites.data[index]?.category ?? '', textColor: Colors.black),
                            tableTitle(sites.data[index]?.totalAmount ?? '', textColor: Colors.black),
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
