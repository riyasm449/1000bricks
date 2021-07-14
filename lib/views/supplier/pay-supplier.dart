import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class SupplierPay extends StatefulWidget {
  final String name;
  final String id;

  const SupplierPay({Key key, this.name, this.id}) : super(key: key);

  @override
  _SupplierPayState createState() => _SupplierPayState();
}

class _SupplierPayState extends State<SupplierPay> {
  TextEditingController amount = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    amount.text = '0';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  addSupplier() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {'supplierId': widget.id, 'date': selectedDate.toString(), 'amount': amount.text};
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio
          .post('http://1000bricks.meatmatestore.in/thousandBricksApi/addNewSupplierPayManagement.php', data: data);
      Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      Commons.snackBar(scaffoldKey, 'Added Successfully...');
      Navigator.pop(context);
      Navigator.pop(context);
      // getDetails();
      print('Added Successfully...');
      print(responce);
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing Some Issue!!!');
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
        centerTitle: true,
        title: Text('Pay Supplier', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Text('Supplier Name: ${widget.name}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                dateTimeCard(),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Amount', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      TextFormField(
                        controller: amount,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      )
                    ])),
                RaisedButton.icon(
                    onPressed: () {
                      if (amount.text != '' && amount.text != '0' && selectedDate != null) {
                        addSupplier();
                      } else
                        Commons.snackBar(scaffoldKey, 'Fill all the fields with *');
                    },
                    icon: Icon(Icons.save),
                    label: Text("ADD SUPPLIER"),
                    color: Commons.bgColor,
                    colorBrightness: Brightness.dark)
              ],
            )),
    );
  }

  Widget dateTimeCard() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text('Date of Pay :  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                      width: 100,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: TextFormField(
                        style: TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                        enabled: false,
                        keyboardType: TextInputType.text,
                        controller: dateController,
                        onSaved: (String val) {
                          // _setDate = val;
                        },
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(top: 0.0)),
                      )))
            ])));
  }
}
