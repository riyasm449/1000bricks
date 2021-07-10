import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/views/site/add-site.dart';
import 'package:thousandbricks/views/site/site-managment.dart';
import 'package:thousandbricks/views/splashScreen.dart';
import 'package:thousandbricks/views/supplier/add-supplier.dart';
import 'package:thousandbricks/views/supplier/supplier-management.dart';

import '/utils/app-theme.dart';
import 'providers/authProvider.dart';
import 'providers/userProvider.dart';
import 'views/home/home-page.dart';
import 'views/loginScreen.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     'This channel is used for important notifications.', // description
//     importance: Importance.high,
//     playSound: true);
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: '1000 Bricks',
          theme: appTheme,
          // home: AddSupplier(),
          home: SplashScreen(),
          routes: <String, WidgetBuilder>{
            '/login': (BuildContext context) => LoginPage(),
            '/home': (BuildContext context) => HomePage(),
            '/site': (BuildContext context) => SiteManagement(),
            '/add-site': (BuildContext context) => AddSite(),
            '/supplier': (BuildContext context) => SupplierManagement(),
            '/add-supplier': (BuildContext context) => AddSupplier(),
          }),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }
}
