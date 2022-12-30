import 'dart:io';

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:skywaysflutter/Provider/PlaceSuggestionProvider.dart';
import 'package:skywaysflutter/Screens/AddPaymentCardScreen.dart';
import 'package:skywaysflutter/Screens/MyRidesScreen.dart';
import 'package:skywaysflutter/Screens/ProfileScreen.dart';
import 'package:skywaysflutter/Screens/RideProcess/BookingConfirmScreen.dart';
import 'package:skywaysflutter/Screens/RideProcess/PaymentScreen.dart';
import 'package:skywaysflutter/Screens/SelectVehicleScreen.dart';
import 'package:skywaysflutter/Screens/SupportScreen.dart';
import 'Screens/HomeScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Services/LocalNotificationService.dart';
//final LocalNotificationService localNotificationService = LocalNotificationService();
import 'package:flutter_stripe/flutter_stripe.dart';
///  to do
/// forgot password
///
///
// TODO: Documentation
//Change parameters{Google api key, office name, BASE_URL, } from lib->Helper->Constants.dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey='pk_test_51MKbx2LedsQzFZxXwlyax3PfZBfTTDUfH66feboIuYmUkwEXlDsNfKLBrIgaQ4dk91oKeo9LvTxykgiVOi3MvOWH00Xf2dvZqd';
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
              accentColor: Colors.blue,
          ),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            LoginScreen.routeName: (ctx) => LoginScreen(),
            SupportScreen.routeName: (ctx) => SupportScreen(),
            ProfileScreen.routeName: (ctx) => ProfileScreen(),
            SelectVehicleScreen.routeName: (ctx) => SelectVehicleScreen(),
            BookingConfirmScreen.routeName: (ctx) => BookingConfirmScreen(),
            PaymentScreen.routeName: (ctx) => PaymentScreen(),
            AddPaymentCardScreen.routeName: (ctx) => AddPaymentCardScreen(),
            MyRidesScreen.routeName: (ctx) => MyRidesScreen(),
          },
          home: SplashScreen(),
        ),
      ),
    );
  }
}


