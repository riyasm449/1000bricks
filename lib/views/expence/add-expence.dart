import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/models/expenses.dart';
import 'package:thousandbricks/models/sites.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/providers/management.dart';
import 'package:thousandbricks/utils/commons.dart';
import 'package:thousandbricks/utils/dio.dart';

class AddExpencePage extends StatefulWidget {
  final ExpenseData expence;

  const AddExpencePage({Key key, this.expence}) : super(key: key);
  @override
  _AddExpencePageState createState() => _AddExpencePageState();
}

class _AddExpencePageState extends State<AddExpencePage> {
  TextEditingController amount = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController expenseBy = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedExpenseLedger = 'Office Expense';
  String selectedPaymentType;
  Sites sites;
  bool isLoading = false;
  List<String> expenceLedger = ['Office Expense', 'Research & Development'];
  bool reinbustment = false;
  DateTime reinbustmentDate = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController reinbustmentDateController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool validate() {
    return amount.text != '0' &&
        amount.text != '' &&
        expenseBy.text != '' &&
        selectedDate != null &&
        selectedExpenseLedger != null;
  }

  addExpence() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> mapData = {
      'dateOfExpense': selectedDate.toString(),
      'description': description.text,
      'expenseBy': expenseBy.text,
      'expenseLedger': selectedExpenseLedger,
      'expenseAmount': amount.text,
      'remarks': comment.text,
      'statusOfReimbursement': reinbustment ? 'yes' : 'no',
      'reimbursementDate': reinbustmentDate.toString(),
      'authorisedBy': 'ADMIN'
    };
    FormData data = FormData.fromMap(mapData);
    try {
      var responce = await dio.post('thousandBricksApi/addNewExpenses.php', data: data);
      Commons.snackBar(scaffoldKey, 'Expense Added');
      clear();
      await Provider.of<DashboardProvider>(context, listen: false).getDashboardData();
      await Provider.of<ManagementProvider>(context, listen: false).getAllGeneralExpenses();
      Navigator.pop(context);
      print(responce);
    } catch (e) {
      Commons.snackBar(scaffoldKey, 'Currently Facing Some Error');
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  clear() {
    description.clear();
    expenseBy.clear();
    comment.clear();
    amount.clear();
  }

  toggleReinbustMent(bool value) {
    setState(() {
      reinbustment = value;
    });
  }

  Future<void> selectReinbustmentDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: reinbustmentDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        reinbustmentDate = picked;
        reinbustmentDateController.text = DateFormat.yMd().format(reinbustmentDate);
      });
  }

  Future<void> selectDate(BuildContext context) async {
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

  @override
  void initState() {
    super.initState();
    dateController.text = DateFormat.yMd().format(DateTime.now());
    reinbustmentDateController.text = DateFormat.yMd().format(DateTime.now());
    if (widget.expence != null) {
      dateController.text = DateFormat.yMd().format(DateTime.parse(widget.expence.dateOfExpense));
      reinbustmentDateController.text = DateFormat.yMd().format(DateTime.parse(widget.expence.dateOfExpense));
      description.text = widget.expence.description;
      expenseBy.text = widget.expence.expenseBy;
      selectedExpenseLedger = widget.expence.expenseLedger;
      comment.text = widget.expence.remarks;
      amount.text = widget.expence.expenseAmount;
      reinbustment = widget.expence.statusOfReimbursement == 'yes' ? true : false;
      reinbustmentDateController.text = DateFormat.yMd().format(DateTime.parse(widget.expence.reimbursementDate));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add General Expense',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  dateCard(
                      title: 'Date Of Expense *:',
                      controller: dateController,
                      onTap: () {
                        selectDate(context);
                      }),
                  textWidget(title: 'Description', controller: description),
                  textWidget(title: 'Expense By *', controller: expenseBy),
                  dropDownBox(
                      list: expenceLedger,
                      onChange: (String value) {
                        if (widget.expence == null)
                          setState(() {
                            selectedExpenseLedger = value;
                          });
                      },
                      value: selectedExpenseLedger,
                      title: 'Expense Ledger *'),
                  textWidget(title: 'Remarks', controller: comment),
                  numberField(title: 'Amount *', controller: amount),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Reimbursement', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        InkWell(
                          onTap: () => toggleReinbustMent(true),
                          child: Row(children: [
                            Text('Yes',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                            SizedBox(width: 10),
                            Icon(reinbustment ? Icons.radio_button_checked : CupertinoIcons.circle, color: Colors.green)
                          ]),
                        ),
                        InkWell(
                          onTap: () => toggleReinbustMent(false),
                          child: Row(children: [
                            Text('No', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                            SizedBox(width: 10),
                            Icon(!reinbustment ? Icons.radio_button_checked : CupertinoIcons.circle, color: Colors.red)
                          ]),
                        ),
                      ],
                    ),
                  ),
                  if (reinbustment)
                    dateCard(
                        title: 'Reimbursement Date',
                        controller: reinbustmentDateController,
                        onTap: () {
                          selectReinbustmentDate(context);
                        }),
                  if (widget.expence == null)
                    FlatButton(
                      color: Commons.bgColor,
                      onPressed: () {
                        if (validate()) {
                          addExpence();
                        } else {
                          Commons.snackBar(scaffoldKey, 'Fill all the fields with *');
                        }
                      },
                      child: Text('ADD EXPENSE', style: TextStyle(color: Colors.white)),
                    )
                ],
              ),
            ),
    );
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
          enabled: widget.expence == null,
          minLines: minLine,
          maxLines: maxLine,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }

  Widget dateCard({@required TextEditingController controller, @required Function() onTap, @required String title}) {
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
                  child: Text(title ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
              InkWell(
                  onTap: onTap,
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
                        controller: controller,
                        decoration: InputDecoration(
                            disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.only(top: 0.0)),
                      )))
            ])));
  }

  Widget dropDownBox(
      {@required List<String> list, @required Function(String) onChange, @required value, @required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
          child: DropdownButton<String>(
            value: value,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            isExpanded: true,
            underline: Container(height: 0),
            onChanged: onChange,
            items: list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        )
      ]),
    );
  }

  Widget numberField(
      {@required String title,
      @required TextEditingController controller,
      num maxLength,
      EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 10)}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          enabled: widget.expence == null,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          maxLength: maxLength,
          decoration: InputDecoration(border: OutlineInputBorder(), contentPadding: padding),
        ),
      ]),
    );
  }
}
