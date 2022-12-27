import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  ///Strings
  static String BASE_URL = 'https://tbmslive.com/taxi_app/WebServices/skyways_custv3.php';
  static String MAP_API_KEY = 'AIzaSyD7d2fm_vjbtWAU_l8ZIxLA1JdDWOUy9Ho';
  static String SUPPORT_PHONE_NUMBER = '+4403333441979';
  static String SUPPORT_OFFICE_EMAIL = "booking@skywayscars.co.uk";
  static const String OFFICE_NAME = "skyways";
  static const String APP_NAME = "SkyWaysCars";

  /// ---------------------------change above infor for cloning-------------------------------------
  static String noInternetConnection = 'Check your internet connection';
  static String someThingWentWrong = 'Something went wrong';
  static String COMPLATED = "completed";
  static String TYPE_CUSTOMER_LOGIN = "customer_login";
  static String TYPE_ALL_VEHICLE_PRICES = "all_vehicle_prices_miles";
  static String TYPE_CUSTOMER_PROFILE_UPDATE = "customer_profile_updated";
  static String TYPE_CUSTOMER_PASSWORD_UPDATE = "customer_changepassword";
  static String TYPE_CUSTOMER_REGISTER = "customer_register";
  static String TYPE_GOOGLE_MAP_KEY = "get_google_key";
  static String CURRENT_LOCATION_LABEL = "Current Location";




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


  static String img_splash_background='assets/images/bg_splash.png';
  static String img_logo='assets/images/ic_app_logo.png';
  static String img_profile='assets/images/ic_profile.png';
  static String img_payment='assets/images/ic_payment.png';
  static String img_logout='assets/images/ic_logout.png';
  static String img_menu_taxi='assets/images/ic_menu_taxi.png';
  static String img_menu_support='assets/images/ic_menu_support.png';
  static String img_ride='assets/images/ic_ride.png';
  static String img_mail='assets/images/ic_mail.png';
  static String img_whatsapp_logo='assets/images/ic_whatsapp_logo.png';
  static String img_call_logo='assets/images/ic_call_logo.png';
  static String img_add_circled_plus='assets/images/ic_plus_circle_outline_black_24dp.png';
  static String img_swap='assets/images/ic_swap.png';
  static String img_map_marker='assets/images/ic_map_marker.png';
  static String img_map_marker_final='assets/images/ic_b.png';
  static String img_map_marker_initial='assets/images/ic_a.png';
  static String img_bag='assets/images/ic_hand_luggage.png';
  static String img_luggage='assets/images/ic_luggage.png';
}
