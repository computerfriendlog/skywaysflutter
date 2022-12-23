import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDatabase {
  static const String _userIsLogined = 'userisLogined';
  static const String _userIsAvailableForJob = 'userisAvailable';

  static String DRIVER_ID = "driver_id_key";
  static String NAME = "driverName_key";
  static String USER_NAME = "username_key";
  static String USER_PASSWORD = "userpassword_key";
  static String THREAT_LEVEL = "threat_level";
  static String USER_EMAIL = "driverEmail_key";
  static String USER_ADDRESS = "driverAddress_key";
  static String USER_CITY = "driverCity_key";
  static String USER_COUNTRY_PREFIX = "countryprefix";
  static String USER_COUNTRY_CODE = "countrycode";
  static String USER_PAYTIME = "paytime";
  static String USER_PAYMENT_SOURCE = "payment_source";
  static String USER_POSTAL_CODE = "driverpostal_key";
  static String USER_MOBILE = "driver_mobile_key";
  static String STARTED_JOB = "started_job_key";
  static String SCREEN_OPEN_ON_NOTIFICATION = "screen_on_notify";
  static String FIREBASE_MSG_TOKEN = "push_notification_token";
  static String GOOGLE_MAP_KEY = "google_map_key";

  static Future setLogined(bool logined) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_userIsLogined, logined);

      return true;
    } catch (e) {
      print("name saving error $e.toString()");
      return null;
    }
  }

  static Future isUserLogined() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? value = prefs.getBool(_userIsLogined);
      print(' current user loggined?  $value');
      print(value);
      return value ?? false;
    } catch (e) {
      print(' current vaccinator name exception...');
      print(e.toString());
      return false;
    }
  }

  static Future setAvailable(bool available) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_userIsAvailableForJob, available);
      print('new user state saved $available');
      return true;
    } catch (e) {
      print("name saving error $e.toString()");
      return null;
    }
  }

  static Future isAvailable() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? value = prefs.getBool(_userIsAvailableForJob);
      print(' current user available?  $value');
      return value ?? false;
    } catch (e) {
      print(' isAvailable exception...');
      print(e.toString());
      return false;
    }
  }

  static saveString(String key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
      print(" ${key}  saved");
    } catch (e) {
      print("Savei string error   $e.toString()");
    }
  }

  static Future getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? 'null';
  }
}
