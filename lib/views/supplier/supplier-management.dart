import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thousandbricks/utils/commons.dart';

class SupplierManagement extends StatefulWidget {
  @override
  _SupplierManagementState createState() => _SupplierManagementState();
}

class _SupplierManagementState extends State<SupplierManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Site Management', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/add-supplier');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(color: Commons.bgColor, borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add Supplier',
                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(
                    Icons.add_circle_rounded,
                    color: Colors.white,
                    size: 30,
                  )
                ],
              ),
            ),
          ),
          Center(child: Text('Supplier Management'))
        ],
      ),
    );
  }
}
