import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';

class MasterInventory extends StatefulWidget {
  @override
  _MasterInventoryState createState() => _MasterInventoryState();
}

class _MasterInventoryState extends State<MasterInventory> {
  DashboardProvider dashboardProvider;
  ManagementProvider managementProvider;
  @override
  void initState() {
    super.initState();
    managementProvider = Provider.of<ManagementProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllStock());
  }

  @override
  Widget build(BuildContext context) {
    dashboardProvider = Provider.of<DashboardProvider>(context);
    managementProvider = Provider.of<ManagementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Master Inventory', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (managementProvider.isLoading) Center(child: CircularProgressIndicator()),
            if (!managementProvider.isLoading && managementProvider.stockManagement == null) Commons.placholder(),
            if (!managementProvider.isLoading && managementProvider.stockManagement != null)
              if (managementProvider.stockManagement.data?.isEmpty) Commons.placholder(),
            if (!managementProvider.isLoading && managementProvider.stockManagement != null)
              if (managementProvider.stockManagement.data != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text('Stock Value : ${dashboardProvider.dashboardData.totalSiteExpense}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                  ),
                ),
            if (!managementProvider.isLoading && managementProvider.stockManagement != null)
              if (managementProvider.stockManagement.data != null)
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text('To pay : ${dashboardProvider.dashboardData.totalSiteExpense}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                  ),
                ),
            if (!managementProvider.isLoading && managementProvider.stockManagement != null)
              if (managementProvider.stockManagement.data != null)
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
            if (!managementProvider.isLoading && managementProvider.stockManagement != null)
              if (managementProvider.stockManagement.data != null)
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
                        for (int index = 0; index < managementProvider.stockManagement.data.length; index++)
                          TableRow(children: [
                            tableTitle(managementProvider.stockManagement.data[index]?.supplierName ?? '',
                                textColor: Colors.black),
                            tableTitle(managementProvider.stockManagement.data[index]?.siteName ?? '',
                                textColor: Colors.black),
                            tableTitle(managementProvider.stockManagement.data[index]?.category ?? '',
                                textColor: Colors.black),
                            tableTitle(managementProvider.stockManagement.data[index]?.totalAmount ?? '',
                                textColor: Colors.black),
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
