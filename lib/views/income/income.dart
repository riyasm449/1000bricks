import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';
import 'package:thousandbricks/views/income/add-income.dart';

class IncomeManagement extends StatefulWidget {
  @override
  _IncomeManagementState createState() => _IncomeManagementState();
}

class _IncomeManagementState extends State<IncomeManagement> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ManagementProvider managementProvider;
  @override
  void initState() {
    super.initState();
    managementProvider = Provider.of<ManagementProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllIncome());
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllSites());
  }

  String getSiteName(String id) {
    String name = '';
    if (managementProvider.siteManagement?.data != null) {
      for (int i = 0; i < managementProvider.siteManagement.data.length; i++) {
        if (managementProvider.siteManagement.data[i].id == id) {
          name = managementProvider.siteManagement.data[i].siteName;
          break;
        }
      }
    }
    return name;
  }

  void deleteData(String id) async {
    setState(() {
      isLoading = true;
    });
    FormData data = FormData.fromMap({'id': id});
    try {
      var responce = await dio.post(
          'http://1000bricks.meatmatestore.in/thousandBricksApi/updateIncomeDetails.php?type=deleteIncome',
          data: data);
      print(responce);
      Commons.snackBar(scaffoldKey, 'Deleted Successfully');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      managementProvider.getAllIncome();
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing some Problem');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    managementProvider = Provider.of<ManagementProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title:
            Text('Income Management', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isLoading || managementProvider.isLoading) CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Table(border: TableBorder.all(), children: [
                TableRow(children: [
                  tableTitle('Site Name', bold: true),
                  tableTitle('Credit Amount ', bold: true),
                  tableTitle('View', bold: true),
                  tableTitle('Delete', bold: true),
                ]),
                if (!managementProvider.isLoading && !isLoading && managementProvider.incomeManagement != null)
                  if (managementProvider.incomeManagement.data?.isNotEmpty)
                    for (int index = 0; index < managementProvider.incomeManagement.data.length; index++)
                      TableRow(children: [
                        tableTitle(getSiteName(managementProvider.incomeManagement.data[index].site),
                            textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                        tableTitle(managementProvider.incomeManagement.data[index].amount, textColor: Colors.black),
                        Center(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AddIncomePage(income: managementProvider.incomeManagement.data[index])));
                                },
                                icon: Icon(Icons.remove_red_eye))),
                        Center(
                            child: IconButton(
                                onPressed: () {
                                  deleteData(managementProvider.incomeManagement.data[index].id);
                                },
                                icon: Icon(Icons.delete)))
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
