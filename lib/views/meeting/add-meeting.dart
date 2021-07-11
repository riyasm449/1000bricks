import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thousandbricks/utils/commons.dart';

class AddMeeting extends StatefulWidget {
  @override
  _AddMeetingState createState() => _AddMeetingState();
}

class _AddMeetingState extends State<AddMeeting> {
  double _height;
  double _width;
  String _setTime, _setDate;
  String _hour, _minute, _time;
  List<String> types = ['Meet in Person', 'Virtual meet', 'Meeting Over Call'];
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  final firestoreInstance = FirebaseFirestore.instance;
  bool isLoading = false;

  ///
  String dateTime;
  String meetingType;
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();

  addMeeting() async {
    setState(() {
      isLoading = true;
    });
    try {
      DateTime dt =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedTime.hour, selectedTime.minute);
      await firestoreInstance.collection("meeting").add({
        "dateTime": dt.toString(),
        "location": location.text,
        "description": description.text,
        "type": meetingType
      }).then((value) {
        print(value.id);
      });
      clear();
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  clear() {
    setState(() {
      dateController.text = DateFormat.yMd().format(DateTime.now());
      timeController.text =
          formatDate(DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [hh, ':', nn, " ", am])
              .toString();
      meetingType = null;
    });

    description.clear();
    location.clear();
  }

  Future<Null> _selectDate(BuildContext context) async {
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

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        timeController.text = _time;
        timeController.text =
            formatDate(DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute), [hh, ':', nn, " ", am])
                .toString();
      });
  }

  @override
  void initState() {
    dateController.text = DateFormat.yMd().format(DateTime.now());

    timeController.text =
        formatDate(DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute), [hh, ':', nn, " ", am])
            .toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Meeting', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              dateTimeCard(),
              textWidget(title: 'Meeting Location', controller: location),
              textWidget(title: 'Details', controller: description),
              dropDownBox(
                  list: types,
                  onChange: (String value) {
                    setState(() {
                      meetingType = value;
                    });
                  },
                  value: meetingType,
                  title: 'Nature of Meeting'),
              FlatButton(
                  color: Commons.bgColor,
                  onPressed: () => addMeeting(),
                  child: Text(
                    'Add Meeting',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ));
  }

  Widget dateTimeCard() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Date Of Meeting:  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
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
                              _setDate = val;
                            },
                            decoration: InputDecoration(
                                disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          )))
                ]))),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text('Time Of Meeting:  ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child: Container(
                          width: 100,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                              style: TextStyle(fontSize: 14),
                              textAlign: TextAlign.center,
                              onSaved: (String val) {
                                _setTime = val;
                              },
                              enabled: false,
                              keyboardType: TextInputType.text,
                              controller: timeController,
                              decoration: InputDecoration(
                                  disabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                                  // labelText: 'Time',
                                  contentPadding: EdgeInsets.all(5)))))
                ])))
      ],
    );
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
