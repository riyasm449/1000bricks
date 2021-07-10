import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneCard extends StatefulWidget {
  final TextEditingController controller;
  final bool enabled;

  const PhoneCard({Key key, @required this.controller, this.enabled}) : super(key: key);

  @override
  _PhoneCardState createState() => _PhoneCardState();
}

class _PhoneCardState extends State<PhoneCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 10,
        ),
        borderCard(
            body: Padding(
          padding: const EdgeInsets.all(11.5),
          child: Icon(
            Icons.call,
            color: Colors.grey,
          ),
        )),
        SizedBox(
          width: 5,
        ),
        borderCard(
            body: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text(
                  '+91',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ))),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: borderCard(
              body: TextFormField(
                controller: widget.controller,
                keyboardType: TextInputType.number,
                // inputFormatters: <TextInputFormatter>[
                //   WhitelistingTextInputFormatter.digitsOnly
                // ],
                decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: InputBorder.none,
                    enabled: widget.enabled ?? true,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget borderCard({@required Widget body}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
            blurRadius: 2.0, // soften the shadow
            spreadRadius: 1.0, //extend the shadow
            offset: Offset(
              1.0, // Move to right 10  horizontally
              1.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      child: body,
    );
  }
}
