import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thousandbricks/models/expenses.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';
import 'package:thousandbricks/views/expence/add-expence.dart';

class ExpenseManagement extends StatefulWidget {
  @override
  _ExpenseManagementState createState() => _ExpenseManagementState();
}

class _ExpenseManagementState extends State<ExpenseManagement> {
  bool isLoading = false;
  String progress;
  Expenses expenses;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
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
      expenses = null;
      var responce = await dio.get(
        'http://1000bricks.meatmatestore.in/thousandBricksApi/getExpenseDetails.php?type=all',
      );
      print(responce);
      setState(() {
        expenses = Expenses.fromJson(jsonDecode(responce.data));
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
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
      getAllSites();
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
            if (isLoading) CircularProgressIndicator(),
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
                    if (!isLoading && expenses != null)
                      if (expenses.data?.isNotEmpty)
                        for (int index = 0; index < expenses.data.length; index++)
                          TableRow(children: [
                            tableTitle(expenses.data[index].expenseBy,
                                textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                            tableTitle(expenses.data[index].expenseAmount, textColor: Colors.black),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  AddExpencePage(expence: expenses.data[index])));
                                    },
                                    icon: Icon(Icons.remove_red_eye))),
                            Center(
                                child: IconButton(
                                    onPressed: () {
                                      deleteData(expenses.data[index].id);
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
