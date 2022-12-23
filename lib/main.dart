import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:skywaysflutter/Provider/PlaceSuggestionProvider.dart';
import 'package:skywaysflutter/Screens/ProfileScreen.dart';
import 'package:skywaysflutter/Screens/SupportScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Services/LocalNotificationService.dart';
//final LocalNotificationService localNotificationService = LocalNotificationService();

///  to do
/// forgot password
///
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //localNotificationService.initializNotifications();
  //bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  //await AndroidAlarmManager.initialize();
  //await Firebase.initializeApp(
  // options: DefaultFirebaseOptions.currentPlatform,
  //);
  // if(Platform.isAndroid) {
  //   AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return OKToast(

      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<PlaceSuggestProvider>(create: (context) => PlaceSuggestProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            primarySwatch: Colors.blue,
            secondaryHeaderColor: Colors.blue,
              accentColor: Colors.blue
          ),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SupportScreen.routeName: (ctx) => SupportScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
          },
          home: SplashScreen(),
        ),
      ),
    );
  }
}


