import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import './provider/badge_provider.dart';
import './provider/push_notification.dart';
import 'screens/home_screen.dart';
import 'service/pushnotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    Firebase.initializeApp(),
  ]);
  PushNotificationService service = new PushNotificationService();
  service.requestNotifications();
  await FirebaseMessaging.instance.subscribeToTopic('SEMVAC_TOPIC');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BadgeCounter(),
        ),
        ChangeNotifierProvider(
          create: (context) => PushNotification(),
        )
      ],
      child: MaterialApp(
        title: 'SEMVAC Covid Viet App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
