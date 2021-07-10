import 'package:flutter/material.dart';
import 'package:thousandbricks/utils/commons.dart';

class PasswordCard extends StatefulWidget {
  final TextEditingController controller;

  const PasswordCard({Key key, @required this.controller}) : super(key: key);

  @override
  _PasswordCardState createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  bool showPassword = true;
  void changeShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: borderCard(
        body: TextFormField(
          obscureText: showPassword,
          controller: widget.controller,
          decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.vpn_key,
                size: 20,
                color: Colors.grey,
              ),
              suffixIcon: IconButton(
                icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                color: Commons.bgColor,
                onPressed: () {
                  changeShowPassword();
                },
              ),
              hintText: 'Password',
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
