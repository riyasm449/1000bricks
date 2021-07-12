import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thousandbricks/providers/dashboard-provider.dart';
import 'package:thousandbricks/views/expence/add-expence.dart';
import 'package:thousandbricks/views/expence/expence.dart';
import 'package:thousandbricks/views/income/add-income.dart';
import 'package:thousandbricks/views/income/income.dart';
import 'package:thousandbricks/views/meeting/add-meeting.dart';
import 'package:thousandbricks/views/meeting/meeting.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationService.instance.start();
  await Firebase.initializeApp();
  // FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DashboardProvider()),
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
            '/add-meeting': (BuildContext context) => AddMeeting(),
            '/meeting': (BuildContext context) => MeetingsManagement(),
            '/add-income': (BuildContext context) => AddIncomePage(),
            '/add-expence': (BuildContext context) => AddExpencePage(),
            '/expence': (BuildContext context) => ExpenseManagement(),
            '/income': (BuildContext context) => IncomeManagement(),
          }),
    );
  }
}
