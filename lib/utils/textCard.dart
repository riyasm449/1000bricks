import 'package:flutter/material.dart';

class TextCard extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final TextEditingController controller;

  const TextCard({Key key, @required this.hintText, this.prefixIcon, this.suffixIcon, @required this.controller})
      : super(key: key);
  @override
  _TextCardState createState() => _TextCardState();
}

class _TextCardState extends State<TextCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: borderCard(
        body: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              prefixIcon: Icon(widget.prefixIcon, color: Colors.grey),
              suffixIcon: Icon(widget.suffixIcon, color: Colors.grey),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 16, color: Colors.grey)),
        ),
      ),
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
