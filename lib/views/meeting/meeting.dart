import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thousandbricks/utils/commons.dart';

class MeetingsManagement extends StatefulWidget {
  @override
  _MeetingsManagementState createState() => _MeetingsManagementState();
}

class _MeetingsManagementState extends State<MeetingsManagement> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: Text('UpComing Meetings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreInstance
                  .collection("meeting")
                  .where("dateTime", isGreaterThan: DateTime.now().toString())
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<TableRow> list = snapshot.data.docs.map((doc) {
                    return TableRow(children: [
                      tableTitle(doc['dateTime'].toString().substring(0, 10)),
                      tableTitle(doc['description']),
                      tableTitle(doc['location']),
                      tableTitle(doc['type']),
                    ]);
                  }).toList();
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Table(
                      border: TableBorder.all(),
                      children: [
                        TableRow(children: [
                          tableTitle('Date', bold: true),
                          tableTitle('Description', bold: true),
                          tableTitle('Location', bold: true),
                          tableTitle('Mode', bold: true),
                        ]),
                        for (int i = 0; i < list.length; i++) list[i]
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            )
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
