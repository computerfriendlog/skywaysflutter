
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperWidgets{
  static TextStyle myAppbarStyle(){
    return  const TextStyle(fontSize: 20,fontWeight: FontWeight.w400);
  }
  static TextStyle text_heading_20b(){
    return  const TextStyle(fontSize: 20,fontWeight: FontWeight.bold);
  }
  static TextStyle text_menu(){
    return  const TextStyle(fontSize: 14,fontWeight: FontWeight.w300);
  }

  static TextStyle text_heading_16(){
    return  const TextStyle(fontSize: 16,fontWeight: FontWeight.w200,color: Colors.black);
  }
  static TextStyle text_heading_16b_grey(){
    return  const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey);
  }
  static TextStyle text_heading_16b_white(){
    return  const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white);
  }
  static TextStyle text_heading_16_300(){
    return  const TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.black);
  }
  static TextStyle text_heading_16_300_grey(){
    return  const TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: Colors.grey);
  }
  static TextStyle text_heading_16bl_300(){
    return  const TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black);
  }

  static TextStyle text_home_time_time_picker(bool hint){
    return TextStyle(fontWeight: FontWeight.w400,fontSize: 14,
        color: hint? Colors.grey: Colors.black );
  }
}