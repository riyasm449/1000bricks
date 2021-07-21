import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';
import 'package:thousandbricks/views/expence/add-expence.dart';

class ExpenseManagement extends StatefulWidget {
  @override
  _ExpenseManagementState createState() => _ExpenseManagementState();
}

class _ExpenseManagementState extends State<ExpenseManagement> {
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ManagementProvider managementProvider;
  @override
  void initState() {
    super.initState();
    managementProvider = Provider.of<ManagementProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllGeneralExpenses());
  }

  void deleteData(String id) async {
    setState(() {
      isLoading = true;
    });
    FormData data = FormData.fromMap({'id': id});
    try {
      var responce = await dio.post(
          'http://1000bricks.meatmatestore.in/thousandBricksApi/updateExpenseDetails.php?type=deleteExpense',
          data: data);
      print(responce);
      Commons.snackBar(scaffoldKey, 'Deleted Successfully');
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      managementProvider.getAllGeneralExpenses();
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
              child: Table(border: TableBorder.all(), // Allows to add a border decoration around your table
                  children: [
                    TableRow(children: [
                      tableTitle('Site Name', bold: true),
                      tableTitle(' Credit Amount ', bold: true),
                      tableTitle('View', bold: true),
                      tableTitle('Delete', bold: true),
                    ]),
                    if (!managementProvider.isLoading &&
                        !isLoading &&
                        managementProvider.generalExpenceManagement != null)
                      if (managementProvider.generalExpenceManagement.data?.isNotEmpty)
                        for (int index = 0; index < managementProvider.generalExpenceManagement.data.length; index++)
                          TableRow(children: [
                            tableTitle(managementProvider.generalExpenceManagement.data[index].expenseBy,
                                textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                            tableTitle(managementProvider.generalExpenceManagement.data[index].expenseAmount,
                                textColor: Colors.black),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => AddExpencePage(
                                                  expence: managementProvider.generalExpenceManagement.data[index])));
                                    },
                                    icon: Icon(Icons.remove_red_eye))),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      deleteData(managementProvider.generalExpenceManagement.data[index].id);
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
