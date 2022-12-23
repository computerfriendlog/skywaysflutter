import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Screens/HomeScreen.dart';
import 'package:skywaysflutter/Screens/LoginScreen.dart';
import 'package:skywaysflutter/Widgets/CustomButton.dart';
import 'package:skywaysflutter/Widgets/CustomTextField.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController controller_ac_name = TextEditingController();
  TextEditingController controller_mail = TextEditingController();
  TextEditingController controller_mobile = TextEditingController();

  TextEditingController controller_address = TextEditingController();
  TextEditingController controller_countryCode = TextEditingController();
  TextEditingController controller_postalCode = TextEditingController();
  TextEditingController controller_city = TextEditingController();
  final restClient = RestClient();
  var _hight;
  var _width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    _hight = mediaQueryData.size.height;
    _width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
                height: _hight * 0.87,
                width: _width,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(15),
                                child: const Text(
                                  'Personal information',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                )),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(
                              _width * 0.95,
                              'Alixender',
                              'Acc. Name',
                              TextInputType.name,
                              controller_ac_name),
                        ),
                        SizedBox(
                          height: _hight * .001,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(
                              _width * 0.95,
                              'abc@gmail.com',
                              'Email',
                              TextInputType.emailAddress,
                              controller_mail,
                              editAble: false),
                        ),
                        SizedBox(
                          height: _hight * .001,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(_width * 0.95, '+44 5656*****',
                              'Mobile', TextInputType.name, controller_mobile),
                        ),
                        SizedBox(
                          height: _hight * .01,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(_width * 0.95, 'city', 'City',
                              TextInputType.name, controller_city),
                        ),
                        SizedBox(
                          height: _hight * .01,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(_width * 0.95, '', 'Address',
                              TextInputType.name, controller_address),
                        ),
                        SizedBox(
                          height: _hight * .01,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: CustomTextField(
                              _width * 0.95,
                              '',
                              'Postal code',
                              TextInputType.number,
                              controller_postalCode),
                        ),
                        SizedBox(
                          height: _hight * .01,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CustomButton('Update profile', _width * 0.95, () {
                          if (controller_ac_name.text
                              .toString()
                              .trim()
                              .isEmpty) {
                            Helper.Toast("Invalid name", Constants.grey);
                          } else if (controller_mobile.text
                                  .toString()
                                  .trim()
                                  .isEmpty ||
                              controller_mobile.text.toString().trim().length <
                                  4) {
                            Helper.Toast("Invalid mobile", Constants.grey);
                          } else {
                            updateProfile(controller_mobile.text.toString(),
                                controller_ac_name.text.toString());
                          }
                        }),
                        SizedBox(
                          height: _hight * .001,
                        ),
                        CustomButton('Change password', _width * 0.95,
                            background: Colors.white, () {
                          updatePassword();
                        }),
                        SizedBox(
                          height: _hight * .001,
                        ),
                        CustomButton('Logout', _width * 0.95,
                            background: Colors.black, () async {
                          bool result = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  //title: Text('Confirmation'),
                                  content: const Text(
                                      'Do you want to logout from this application?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                false); // dismisses only the dialog and returns false
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop(
                                                true); // dismisses only the dialog and returns true
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              });
                          if (result) {
                            print('logout');
                            if (Helper.logOut()) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  LoginScreen.routeName,
                                  (Route<dynamic> route) => false);
                              //Navigator.of(context).pushNamed(LoginScreen.routeName);
                            } else {
                              Helper.Toast('Logout failed, try again',
                                  Constants.toast_red);
                            }
                          } else {
                            print('don\'t logout');
                          }
                        }),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void initData() async {
    controller_ac_name.text = name;
    controller_mail.text = driver_mail;
    controller_mobile.text = driver_phone;
    controller_address.text =
        await LocalDatabase.getString(LocalDatabase.USER_ADDRESS);
    controller_countryCode.text =
        await LocalDatabase.getString(LocalDatabase.USER_COUNTRY_CODE);
    controller_postalCode.text =
        await LocalDatabase.getString(LocalDatabase.USER_POSTAL_CODE);
    controller_city.text =
        await LocalDatabase.getString(LocalDatabase.USER_CITY);
    setState(() {});
  }

  void updateProfile(String mobile, String name) async {
    Helper.showLoading(context);
    String user_id = await LocalDatabase.getString(LocalDatabase.DRIVER_ID);
    final parameters = {
      'type': Constants.TYPE_CUSTOMER_PROFILE_UPDATE,
      'mobile': mobile,
      'address': controller_address.text.toString(),
      'office_name': Constants.OFFICE_NAME,
      'title': 'male',
      'countrycode': controller_countryCode.text.toString(), //field
      'username': controller_mail.text.toString(),
      'email': controller_mail.text.toString(),
      'name': name,
      'customer_id': user_id,
      'post_code': controller_postalCode.text.toString(),
      'city': controller_city.text.toString(),
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('update profile, response is..... ${res}');

    if (res['RESULT'] == 'OK') {
      LocalDatabase.saveString(
          LocalDatabase.USER_NAME, controller_mail.text.toString());
      LocalDatabase.saveString(
          LocalDatabase.NAME, controller_ac_name.text.toString());
      LocalDatabase.saveString(
          LocalDatabase.USER_MOBILE, controller_mobile.text.toString());
      LocalDatabase.saveString(
          LocalDatabase.USER_EMAIL, controller_mail.text.toString());
      LocalDatabase.saveString(
          LocalDatabase.USER_ADDRESS, controller_address.text.toString());
      LocalDatabase.saveString(
          LocalDatabase.USER_CITY, controller_city.text.toString());
      LocalDatabase.saveString(LocalDatabase.USER_POSTAL_CODE,
          controller_postalCode.text.toString());
      LocalDatabase.saveString(LocalDatabase.USER_COUNTRY_CODE,
          controller_countryCode.text.toString());
    }
    Navigator.pop(context);
  }

  void updatePassword() {
    TextEditingController controller_old_pswd = TextEditingController();
    TextEditingController controller_new_pswd = TextEditingController();
    TextEditingController controller_cnfrm_pswd = TextEditingController();
    Dialog rejectDialog_with_reason = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: _width * 0.9,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      "Hi! ${name}, update your password here",
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              CustomTextField(_width * 0.6, 'Old password', 'Step 1:',
                  TextInputType.visiblePassword, controller_old_pswd),
              CustomTextField(_width * 0.6, 'New password', 'Step 2:',
                  TextInputType.visiblePassword, controller_new_pswd),
              CustomTextField(_width * 0.6, 'Confirm password', 'Step 3:',
                  TextInputType.visiblePassword, controller_cnfrm_pswd),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton('Update', _width * 0.3, () {
                    print('click');
                    //update password
                    if (controller_old_pswd.text.toString().trim().isEmpty) {
                      Helper.Toast(
                          'Old password required', Constants.toast_grey);
                    } else if (controller_new_pswd.text
                        .toString()
                        .trim()
                        .isEmpty) {
                      Helper.Toast(
                          'New password required', Constants.toast_grey);
                    } else if (controller_cnfrm_pswd.text
                        .toString()
                        .trim()
                        .isEmpty) {
                      Helper.Toast(
                          'Confirm password required', Constants.toast_grey);
                    } else if (controller_new_pswd.text.toString() !=
                        controller_cnfrm_pswd.text.toString()) {
                      Helper.Toast(
                          'New password does\'t match', Constants.toast_grey);
                    } else {
                      updatePasswordApi(controller_old_pswd.text.toString(),
                          controller_new_pswd.text.toString());
                    }
                  }),
                  CustomButton('Cancel', _width * 0.3, background: Colors.white,
                      () {
                    Navigator.pop(context);
                  }),
                ],
              )
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => rejectDialog_with_reason);
  }

  void updatePasswordApi(String old_pswd, String new_pswd) async {
    Helper.showLoading(context);
    String user_id = await LocalDatabase.getString(LocalDatabase.DRIVER_ID);
    String mail = await LocalDatabase.getString(LocalDatabase.USER_EMAIL);
    String usernm = await LocalDatabase.getString(LocalDatabase.USER_NAME);
    final parameters = {
      'type': Constants.TYPE_CUSTOMER_PASSWORD_UPDATE,
      'office_name': Constants.OFFICE_NAME,
      'username': usernm,
      'customer_id': user_id,
      'email': mail,
      'oldpassword': old_pswd,
      'newpassword': new_pswd,
      'device_type': deviceType,
    };

    final respose = await restClient.get(Constants.BASE_URL + "", headers: {}, body: parameters);

    final res = jsonDecode(respose.data);
    print('update password, response is..... ${res}');

    if (res['RESULT'] == 'OK' && res['DATA']=='Your password changed successfully') {
      LocalDatabase.saveString(LocalDatabase.USER_PASSWORD, new_pswd);
      Navigator.pop(context);//stop loader
      Navigator.pop(context);//dismiss dialog
    }else{
      Navigator.pop(context);//stop loader
      Helper.Toast(res['DATA'], Constants.toast_red);
    }

  }
}
