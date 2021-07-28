import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/views/supplier/supplier-details.dart';

class SupplierManagement extends StatefulWidget {
  @override
  _SupplierManagementState createState() => _SupplierManagementState();
}

class _SupplierManagementState extends State<SupplierManagement> {
  ManagementProvider managementProvider;
  @override
  void initState() {
    super.initState();
    managementProvider = Provider.of<ManagementProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllSuppliers());
  }

  @override
  Widget build(BuildContext context) {
    managementProvider = Provider.of<ManagementProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Supplier Management',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          if (managementProvider.isLoading) Center(child: CircularProgressIndicator()),
          if (!managementProvider.isLoading && managementProvider.supplierManagement == null) Commons.placholder(),
          if (!managementProvider.isLoading && managementProvider.supplierManagement != null)
            if (managementProvider.supplierManagement.data?.isEmpty) Commons.placholder(),
          if (!managementProvider.isLoading && managementProvider.supplierManagement != null)
            if (managementProvider.supplierManagement.data?.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                  child: Table(border: TableBorder.all(), children: [
                    TableRow(children: [
                      tableTitle('Supplier Name', bold: true),
                      tableTitle('Supplier Location', bold: true),
                      tableTitle('View', bold: true),
                      tableTitle('Edit', bold: true),
                    ]),
                    for (int index = 0; index < managementProvider.supplierManagement.data.length; index++)
                      TableRow(children: [
                        tableTitle(managementProvider.supplierManagement.data[index].companyName,
                            textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                        tableTitle(managementProvider.supplierManagement.data[index].address, textColor: Colors.black),
                        Center(
                            child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) => SupplierDetailsPage(
                                                id: managementProvider.supplierManagement.data[index].id,
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
                                                id: managementProvider.supplierManagement.data[index].id,
                                                edit: true,
                                              )));
                                },
                                icon: Icon(Icons.edit)))
                      ])
                  ]))
        ])));
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
