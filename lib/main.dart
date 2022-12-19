import 'package:flutter/material.dart';

import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SplashScreen.dart';
import 'Services/LocalNotificationService.dart';

//final LocalNotificationService localNotificationService = LocalNotificationService();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //localNotificationService.initializNotifications();
  //bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  //await AndroidAlarmManager.initialize();
  //await Firebase.initializeApp(
   // options: DefaultFirebaseOptions.currentPlatform,
  //);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),

      },
      home: SplashScreen(),
    );
  }
}


