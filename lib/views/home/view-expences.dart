import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';

class DashboardExpenses extends StatefulWidget {
  @override
  _DashboardExpensesState createState() => _DashboardExpensesState();
}

class _DashboardExpensesState extends State<DashboardExpenses> {
  DashboardProvider dashboardProvider;
  @override
  Widget build(BuildContext context) {
    dashboardProvider = Provider.of<DashboardProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            card('Total Income', '${dashboardProvider.dashboardData?.totalIncome}', dir: '/income'),
            card('General Expense', '${dashboardProvider.dashboardData?.totalGeneralExpenses}', dir: '/expence'),
            card('Available', '${dashboardProvider.dashboardData?.availableAmount}', dir: '/income'),
            card('Stock Value', '${dashboardProvider.dashboardData?.totalSiteExpense}', dir: '/stock'),
            card('Supplier Balance', '${dashboardProvider.dashboardData?.outStandingAmount}', dir: '/stock'),
          ],
        ),
      ),
    );
  }

  Widget card(String title, String value, {String dir}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, dir);
        },
        child: Card(
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(value ?? '',
                      style: TextStyle(color: Commons.bgColor, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
