import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  ///Strings
  ///static String BASE_URL = 'https://guardapps.tbmslive.com/taxi_app/WebServices/';
  static String BASE_URL = 'https://guardapps.tbmslive.com/taxi_app/WebServices/guardappv5.php';
  static String noInternetConnection = 'Check your internet connection';
  static String COMPLATED = "completed";


  ///icons
  static IconData ic_calender = Icons.calendar_month_outlined;
  static IconData ic_location = Icons.location_on_outlined;
  static IconData ic_arrow_forword = Icons.arrow_forward_ios_rounded;
  static IconData ic_phone = Icons.phone;
  static IconData ic_tik = Icons.done;
  static IconData ic_add = Icons.add;
  static IconData ic_cross = Icons.cancel_outlined;
  static IconData ic_camera = Icons.camera_alt;

  ///colors
  static Color toast_grey = Colors.grey;
  static Color toast_red = Colors.red;
  static Color grey = Colors.grey;
  static Color redAccent =
      Colors.redAccent.withOpacity(0.8) ?? Colors.redAccent;
}