import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  print(message.data);
  flutterLocalNotificationsPlugin.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      ));
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token;
  @override
  void initState() {
    super.initState();
    var initialzationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: initialzationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: android?.smallIcon,
              ),
            ));
      }
    });
    getToken();
  }

  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }

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
