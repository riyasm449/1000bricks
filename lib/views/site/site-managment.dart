import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/views/site/site-details.dart';

class SiteManagement extends StatefulWidget {
  @override
  _SiteManagementState createState() => _SiteManagementState();
}

class _SiteManagementState extends State<SiteManagement> {
  ManagementProvider managementProvider;
  @override
  void initState() {
    super.initState();
    managementProvider = Provider.of<ManagementProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => managementProvider.getAllSites());
  }

  @override
  Widget build(BuildContext context) {
    managementProvider = Provider.of<ManagementProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Site Management', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (managementProvider.isLoading) CircularProgressIndicator(),
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
                    if (!managementProvider.isLoading && managementProvider.siteManagement != null)
                      if (managementProvider.siteManagement.data?.isNotEmpty)
                        for (int index = 0; index < managementProvider.siteManagement.data.length; index++)
                          if (managementProvider.siteManagement.data[index].statusOfProject != 'Project Terminated')
                            TableRow(children: [
                              tableTitle(managementProvider.siteManagement.data[index].siteName,
                                  textColor: Colors.black, color: index.isEven ? Colors.blueGrey : null),
                              tableTitle(managementProvider.siteManagement.data[index].siteLocation,
                                  textColor: Colors.black),
                              Center(
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) => SiteDetailsPage(
                                                    id: managementProvider.siteManagement.data[index].id)));
                                      },
                                      icon: Icon(Icons.remove_red_eye))),
                              Center(
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) => SiteDetailsPage(
                                                  id: managementProvider.siteManagement.data[index].id, edit: true)));
                                    },
                                    icon: Icon(Icons.edit)),
                              ),
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
