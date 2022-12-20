import 'dart:io';
import 'package:flutter/material.dart';

//import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

//import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:oktoast/oktoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:geocoding/geocoding.dart';
import '../Helper/CountryCodes.dart';

//import '../APIs/APICalls.dart';
//import '../Services/LocalNotificationService.dart';
Placemark? myAdress;

class Helper {
  static Position currentPositon = Position(
      longitude: 33.6163723,
      latitude: 72.8059114,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  static String currentAddress = '';

  static Future<bool> isInternetAvailble() async {
    bool _isConnectionSuccessful = false;
    try {
      final response = await InternetAddress.lookup('www.google.com');
      _isConnectionSuccessful = response.isNotEmpty;
    } on SocketException catch (e) {
      _isConnectionSuccessful = false;
    }
    return _isConnectionSuccessful;
  }

  static bool logOut() {
    print('logout is going heree.....');
    bool logout = false;
    try {
      //LocalDatabase.saveString(LocalDatabase.GUARD_ID, '');
      //LocalDatabase.saveString(LocalDatabase.NAME, '');
      //LocalDatabase.saveString(LocalDatabase.USER_NAME, '');
      //LocalDatabase.saveString(LocalDatabase.USER_EMAIL, '');
      //LocalDatabase.saveString(LocalDatabase.USER_ADDRESS, '');
      //LocalDatabase.saveString(LocalDatabase.USER_MOBILE, '');
      //LocalDatabase.setLogined(false);
      logout = true;
    } catch (e) {
      logout = false;
    }
    return logout;
  }

  /* static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static textviaSim(String phone, String msg) async {
    if (Platform.isAndroid) {
      var uri = 'sms:$phone?body=$msg%20there';
      await launch(uri);
    } else if (Platform.isIOS) {
      // iOS
      var uri = 'sms:$phone&body=$msg%20there';
      await launch(uri);
    }
  }*/

  static Future<Position> determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    //print('0.......');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    //print('1.......');

    permission = await Geolocator.checkPermission();
    //print('2.......');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    // print('4.......');

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    //print('5.......');
    try {
      currentPositon = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 6));
    } catch (e) {
      print('6.......$e');
    }

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentPositon.latitude, currentPositon.longitude);
      print('current address ');
      print(placemarks[0].name);
      myAdress = placemarks[0];
      currentAddress =
          '${myAdress!.street} , ${myAdress!.subLocality}, ${myAdress!.postalCode}, ${myAdress!.country}';
    } catch (e) {
      print('exception while getting address...');
    }
    return currentPositon;
  }

  static void Toast(String msg, Color clr) {
    showToast(
      msg,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      backgroundColor: clr,
      radius: 5.0,
      textPadding: const EdgeInsets.all(8),
      textStyle: const TextStyle(fontSize: 20.0),
    );
  }

  static showLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.bouncingBall(
            color: Theme.of(context).primaryColor,
            size: 70,
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /*static double distanceLatLong(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }*/

  static Widget LoadingWidget(BuildContext context) {
    return SizedBox(
      child: LoadingAnimationWidget.bouncingBall(
        color: Theme.of(context).primaryColor,
        //leftDotColor: const Color(0xFF1A1A3F),
        //rightDotColor: const Color(0xFFEA3799),
        size: 70,
      ),
    );
  }

  static DateTime getCurrentTime() {
    return DateTime.now();
  }

  static void msgDialog(
      BuildContext context, String msg, Function()? _function_handler) {
    Dialog rejectDialog_with_reason = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Hi! ",
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              Text(
                msg,
                style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: _function_handler,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => rejectDialog_with_reason);
  }

  static Future<TimeOfDay> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked_s != null) selectedTime = picked_s;
    return selectedTime;
  }

  static Future<DateTime> selectDate(BuildContext context) async {
    DateTime selectedTime = DateTime.now();
    final DateTime? picked_s = await showDatePicker(
        context: context,
        initialDate: Helper.getCurrentTime(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked_s != null) selectedTime = picked_s;
    return selectedTime;
  }

  static trackAndNotify(String lat, String long) {
    // LocalNotificationService localNotification = LocalNotificationService();
    // localNotification.initializNotifications();
    // localNotification.sendNotification('Now you are here ', "${lat},${long}");
    //APICalls.trackLocation(lat, long);
  }

/*  static checkJobAndTrack() async {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      print('[location sanwal] - ${location}');
      print('[location sanwal] - ${location.coords.latitude}');
      Helper.trackAndNotify(location.coords.latitude.toString(),
          location.coords.longitude.toString());
    });
    // Fired whenever the plugin changes motion-state (stationary->moving and vice-versa)
    bg.BackgroundGeolocation.onMotionChange((bg.Location location) {
      print('[motionchange sanwal] - ${location}');
      Helper.trackAndNotify(location.coords.latitude.toString(),
          location.coords.longitude.toString());
    });
    // Fired whenever the state of location-services changes.  Always fired at boot
    bg.BackgroundGeolocation.onProviderChange((bg.ProviderChangeEvent event) {
      print('[providerchange sanwal] - ${event}');
    });
    bg.BackgroundGeolocation.ready(bg.Config(
      notification: bg.Notification(
        title: 'SMS Guard portal',
        channelId: 'chnl',
        channelName: 'abd',
        sticky: true,
        text: 'Tracking location',
        smallIcon: 'ic_notification',
      ),
      reset: true,
      // <-- set true to ALWAYS apply supplied config; not just at first launch.
      fastestLocationUpdateInterval: 10 * 1000,
      //500  //it have to set 10 min
      locationUpdateInterval: 10 * 1000,
      //1000
      //1000 is 1 sec
      heartbeatInterval: 20 * 1000,
      desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
      distanceFilter: 0.01,
      //0.001
      stopOnTerminate: false,
      forceReloadOnSchedule: true,
      startOnBoot: true,
      isMoving: true,
      // very effectiv,
      debug: true,
      stopTimeout: 12 * 60,
      logLevel: bg.Config.LOG_LEVEL_VERBOSE,
      enableHeadless: true,
      // foregroundService: true,
      //   preventSuspend: true,
    )).then((bg.State state) async {
      print('location service started .....state is ${state}');
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
        // Force moving state immediately.  Plugin will now begin recording a location each distanceFilter meters.
        await bg.BackgroundGeolocation.changePace(true);
      }
    });

  }

  static stopTracking() {
    bg.BackgroundGeolocation.stop();
  }*/

  static String  getCountryCode(String country) {
    String a='00';
    CountryCodes.getCountryCodes()['countries'].forEach((value){
      if(value['name']==country){
        a=value['code'];
        return;
      }
    });
    return a;
  }
}
