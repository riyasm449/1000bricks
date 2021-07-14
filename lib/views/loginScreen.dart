import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/userProvider.dart';
import 'package:thousandbricks/utils/commons.dart';

import '/utils/passwordCard.dart';
import '/utils/textCard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _mailFeild = TextEditingController();
  UserProvider userProvider;
  bool isLoading = false;

  setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(minWidth: 300, maxWidth: 600),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 1),
                  TextCard(
                    hintText: 'Mail ID',
                    controller: _mailFeild,
                    prefixIcon: Icons.mail,
                  ),
                  PasswordCard(controller: _passwordField),
                  loginButton(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/web.png",
                          width: 35, fit: BoxFit.cover),
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/youtube.png",
                          width: 35, fit: BoxFit.cover),
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/facebook.png",
                          width: 35, fit: BoxFit.cover),
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/instagram-new.png",
                          width: 35, fit: BoxFit.cover),
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/twitter.png",
                          width: 35, fit: BoxFit.cover),
                      Image.network("https://img.icons8.com/cute-clipart/64/000000/linkedin.png",
                          width: 35, fit: BoxFit.cover),
                    ],
                  ),
                  Spacer(flex: 2)
                ],
              ),
            ),
          ),
        ));
  }

  Widget loginButton() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () async {
          if (!isLoading) await login();
        },
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: !isLoading ? Commons.bgColor : Commons.bgColor.withOpacity(.8)),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SIGN IN', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
              if (isLoading) SizedBox(width: 25),
              if (isLoading) CircularProgressIndicator.adaptive(backgroundColor: Colors.white, strokeWidth: 2)
            ],
          ),
        ),
      ),
    );
  }

  bool validateEmail(String value) {
    Pattern pattern = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return true;
    else
      return false;
  }

  Future<void> login() async {
    /// checks whether the mail is empty ///
    if (_mailFeild.text.trim() == '') {
      showAlertDialog(context, title: 'Incomplete', content: 'Mail id is Empty');
    }

    /// checks whether the mail is valid ///
    else if (validateEmail(_mailFeild.text)) {
      showAlertDialog(context, title: 'Mail Id', content: 'Enter proper mail id');
    }

    /// checks whether the password is empty ///
    else if (_passwordField.text.trim() == '') {
      showAlertDialog(context, title: 'Incomplete', content: 'Password is empty');
    } else {
      setLoading(true);

      /// firebase login and Error handling ///
      try {
        /// trying to login ///
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _mailFeild.text.trim(), password: _passwordField.text.trim());
        String token = await FirebaseMessaging.instance.getToken();
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({'token': token});
        //
        userProvider.getUserDetails(FirebaseAuth.instance.currentUser.uid);
        Navigator.pushReplacementNamed(context, '/home');
        setLoading(false);
      } catch (e) {
        setLoading(false);

        /// user not found error ///
        if (e.code == 'user-not-found') {
          showAlertDialog(context, title: 'Login Failed', content: 'User not found');
          print('================> User not found <===================');
        }

        /// wrong password error ///
        else if (e.code == 'wrong-password') {
          showAlertDialog(context, title: 'Login Failed', content: 'Wrong password');
          print('================> Wrong password <===================');
        }

        /// other errors ///
        else {
          showAlertDialog(context, title: 'Login Failed', content: 'Something went wrong');
          print('============> ${e.code} <============');
        }
      }
    }
  }

  showAlertDialog(BuildContext context, {String title, String content}) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(content),
          actions: [
            okButton,
          ],
        );
      },
    );
  }
}
