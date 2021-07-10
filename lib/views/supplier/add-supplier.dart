import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class AddSupplier extends StatefulWidget {
  @override
  _AddSupplierState createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  TextEditingController companyName = TextEditingController();
  TextEditingController contactPerson = TextEditingController();
  TextEditingController contactNumber = TextEditingController();
  TextEditingController alternateNumber = TextEditingController();
  TextEditingController GSTnumber = TextEditingController();
  TextEditingController accNumber = TextEditingController();
  TextEditingController bankName = TextEditingController();
  TextEditingController IFSC = TextEditingController();
  TextEditingController bankBranch = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mail = TextEditingController();

  // addForm() async {
  //   List estimationFiles = [];
  //   List renderFiles = [];
  //   List drawingFiles = [];
  //   print([estimationFiles, renderFiles, drawingFiles]);
  //   Map<String, dynamic> mapData = {
  //     'siteName': companyName,
  //     'siteLocation': contactPerson,
  //     'clientName': contactNumber,
  //     'clientBillingAddress': alternateNumber,
  //     'clientGST': GSTnumber,
  //     'mailId': accNumber,
  //     'category': category,
  //     'estimationlink': estimationLinks,
  //     'estimationfile': estimationFiles,
  //     'renderlink': rendersLinks,
  //     'renderfile': renderFiles,
  //     'drawinglink': drawingsLinks,
  //     'drawingfile': drawingFiles,
  //     'start': startedOn,
  //     'end': endedOn,
  //     'status': status
  //   };
  //   FormData data = FormData.fromMap(mapData);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Supplier', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            textWidget(title: 'Company Name', controller: companyName),
            textWidget(title: 'Contact Person', controller: contactPerson),
            textWidget(title: 'Contact Number', controller: contactNumber),
            textWidget(title: 'Alternate Contact Number', controller: contactNumber),
            textWidget(title: 'Mail Id', controller: mail),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Text('Bank Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
              child: Column(
                children: [
                  textWidget(title: 'Account Number', controller: accNumber),
                  textWidget(title: 'Bank Name', controller: bankName),
                  textWidget(title: 'Bank Branch', controller: bankBranch),
                  textWidget(title: 'IFSC Code', controller: IFSC),
                ],
              ),
            ),
            textWidget(
                title: 'Billing Address',
                controller: address,
                minLine: 5,
                maxLine: 8,
                padding: const EdgeInsets.all(10)),
            textWidget(title: 'Client GST', controller: GSTnumber),

            // RaisedButton.icon(
            //     onPressed: () {
            //       addForm();
            //     },
            //     icon: Icon(Icons.save),
            //     label: Text("ADD"),
            //     color: Commons.bgColor,
            //     colorBrightness: Brightness.dark)
          ],
        ),
      ),
    );
  }

  Widget datePicker(BuildContext context,
      {@required String title, @required DateTime dateTime, @required Function onPressed()}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            if (dateTime != null)
              Text("${dateTime.toLocal()}".split(' ')[0], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            RaisedButton(onPressed: onPressed, child: Text('Select date'))
          ]))
    ]);
  }

  Widget textWidget(
      {@required String title,
      @required TextEditingController controller,
      num minLine,
      num maxLine,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          minLines: minLine,
          maxLines: maxLine,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
