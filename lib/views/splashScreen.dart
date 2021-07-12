import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/userProvider.dart';
import 'package:thousandbricks/utils/commons.dart';

import '/providers/authProvider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthProvider authProvider = AuthProvider();
  UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), checkLoginStatus);
  }

  Future<void> checkLoginStatus() async {
    if (authProvider.auth.currentUser != null) {
      await userProvider.getUserDetails(FirebaseAuth.instance.currentUser.uid);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Center(
      //   child: Image.asset('assets/images/logo.png'),
      // ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Commons.bgColor, Commons.colorFromHex('#8f0613')],
                begin: const FractionalOffset(0, 0),
                end: const FractionalOffset(1, 1))),
        child: Column(
          children: [
            Spacer(),
            Text('Thousand Bricks', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Spacer(),
            Text('MacBerries', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
