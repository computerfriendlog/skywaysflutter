import 'package:flutter/material.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Screens/HomeScreen.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTextField.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller_accountName = TextEditingController();
  TextEditingController _controller_mobile = TextEditingController();
  TextEditingController _controller_confrimPassword = TextEditingController();
  TextEditingController _controller_UserName = TextEditingController();
  TextEditingController _controller_Password = TextEditingController();

  //final restClient = RestClient();
  bool rememberMe = false;
  final restClient = RestClient();
  bool isLoginSelected = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_controller_officeName.text = 'sms';
    //_controller_UserName.text = 'test';
    //_controller_Password.text = 'test';
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isLoginSelected ? 'Login' : 'Sign Up',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              width: _width,
              height: _hight * 0.9,
              child: Stack(
                children: [
                  Image.asset(
                      height: _hight * 0.9,
                      width: _width,
                      fit: BoxFit.cover,
                      Constants.img_splash_background),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                              height: _hight * 0.15,
                              width: _width * 0.6,
                              //fit: BoxFit.cover,
                              Constants.img_logo),
                          !isLoginSelected
                              ? CustomTextField(
                                  _width * 0.95,
                                  'Account name',
                                  'User name',
                                  TextInputType.name,
                                  _controller_accountName)
                              : Container(),
                          CustomTextField(
                              //for both
                              _width * 0.95,
                              'jon.example@deo.com',
                              'Email',
                              TextInputType.emailAddress,
                              _controller_UserName),
                          !isLoginSelected
                              ? CustomTextField(
                                  _width * 0.95,
                                  '+44 78985*****',
                                  'Mobile',
                                  TextInputType.name,
                                  _controller_mobile)
                              : Container(),
                          CustomTextField(
                              //for both
                              _width * 0.95,
                              '*******',
                              'Password',
                              TextInputType.visiblePassword,
                              _controller_Password),
                          !isLoginSelected
                              ? CustomTextField(
                                  _width * 0.95,
                                  '*******',
                                  'Confirm password',
                                  TextInputType.name,
                                  _controller_confrimPassword)
                              : Container(),
                          isLoginSelected
                              ? Row(
                                  children: [
                                    Checkbox(
                                        value: rememberMe,
                                        onChanged: (newValue) {
                                          print('check box hit...$newValue');
                                          setState(() {
                                            rememberMe = newValue as bool;
                                          });
                                        }),
                                    const Text(
                                      "Remember Me",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                )
                              : Container(),
                        ],
                      ),
                      Column(
                        children: [
                          CustomButton(isLoginSelected ? 'Login' : 'Sign Up',
                              _width * 0.85, () {
                            Helper.isInternetAvailble().then((value) => {
                                  if (value == true)
                                    {
                                      if (isLoginSelected)
                                        {
                                          if (_controller_UserName.text
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                            {
                                              Helper.Toast("Invalid Username",
                                                  Constants.grey)
                                            }
                                          else if (_controller_Password.text
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                            {
                                              Helper.Toast("Invalid Password",
                                                  Constants.toast_red)
                                            }
                                          else
                                            {
                                              //login here
                                              loginUser(
                                                  _controller_UserName.text
                                                      .toString(),
                                                  _controller_Password.text
                                                      .toString())
                                            }
                                        }
                                      else
                                        {
                                          //signUp here
                                          if (_controller_accountName.text
                                              .toString()
                                              .trim()
                                              .isEmpty)
                                            {
                                              Helper.Toast(
                                                  "Invalid Account name",
                                                  Constants.grey)
                                            }
                                          else if (_controller_UserName.text
                                              .toString()
                                              .trim()
                                              .isEmpty) //its email
                                            {
                                              Helper.Toast("Invalid email",
                                                  Constants.toast_red)
                                            }
                                          else if (_controller_mobile.text
                                              .toString()
                                              .trim()
                                              .isEmpty) //its email
                                            {
                                              Helper.Toast("Invalid mobile",
                                                  Constants.toast_red)
                                            }
                                          else if (_controller_Password.text
                                              .toString()
                                              .trim()
                                              .isEmpty) //its email
                                            {
                                              Helper.Toast("Invalid password",
                                                  Constants.toast_red)
                                            }
                                          else if (_controller_Password.text !=
                                              _controller_confrimPassword
                                                  .text) //its email
                                            {
                                              Helper.Toast(
                                                  "Password doesn't match",
                                                  Constants.toast_red)
                                            }
                                          else
                                            {
                                              //login here
                                              RegisterUser(
                                                  _controller_accountName.text
                                                      .toString()
                                                      .trim(),
                                                  _controller_UserName.text
                                                      .toString()
                                                      .trim(),
                                                  _controller_mobile.text
                                                      .toString()
                                                      .trim(),
                                                  _controller_Password.text
                                                      .toString()
                                                      .trim())
                                            }
                                        }
                                    }
                                  else
                                    {
                                      Helper.Toast(
                                          Constants.noInternetConnection,
                                          Constants.toast_red)
                                    }
                                });
                          }),
                          isLoginSelected
                              ? Text(
                                  'Forgot your password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                      const SizedBox(),
                      Container(
                        width: _width * 0.9,
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isLoginSelected
                                      ? 'New to Skyway cars'
                                      : 'Do you have an account?',
                                  style: HelperWidgets.text_heading_16(),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                isLoginSelected = !isLoginSelected;
                                setState(() {});
                              },
                              child: Card(
                                child: Container(
                                    width: _width * 0.91,
                                    padding: const EdgeInsets.all(13),
                                    child: Text(
                                      isLoginSelected ? 'Sign Up' : 'Login',
                                      style: HelperWidgets.text_heading_16(),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  loginUser(String username, String pswrd) async {
    //await Helper.determineCurrentPosition();
    Helper.showLoading(context);
    final parameters = {
      'type': Constants.TYPE_CUSTOMER_LOGIN,
      'username': username,
      'password': pswrd,
      'office_name': Constants.OFFICE_NAME,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('login, response is..... ${res}');

    if (res['RESULT'] == 'OK') {
      LocalDatabase.saveString(LocalDatabase.USER_NAME, res['DATA']['username']);
      LocalDatabase.saveString(
          LocalDatabase.DRIVER_ID, res['DATA']['customer_id']); //title
      LocalDatabase.saveString(LocalDatabase.NAME, res['DATA']['Account_name']);
      LocalDatabase.saveString(LocalDatabase.USER_MOBILE, res['DATA']['mobile']);
      LocalDatabase.saveString(LocalDatabase.USER_EMAIL, res['DATA']['email']);
      LocalDatabase.saveString(
          LocalDatabase.USER_ADDRESS, res['DATA']['address']);
      LocalDatabase.saveString(LocalDatabase.USER_CITY, res['DATA']['city']);
      LocalDatabase.saveString(
          LocalDatabase.USER_POSTAL_CODE, res['DATA']['post_code']);
      LocalDatabase.saveString(
          LocalDatabase.USER_COUNTRY_PREFIX, res['DATA']['countryprefix']);
      LocalDatabase.saveString(
          LocalDatabase.USER_COUNTRY_CODE, res['DATA']['countrycode']);
      LocalDatabase.saveString(
          LocalDatabase.USER_PAYMENT_SOURCE, res['DATA']['payment']);
      LocalDatabase.saveString(
          LocalDatabase.USER_PAYTIME, res['DATA']['paytime']);
      LocalDatabase.setLogined(true);
      Navigator.pop(context);
      Navigator.pushNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pop(context);
      Helper.Toast('Can\'t login, try again', Constants.toast_red);
    }
  }

  RegisterUser(String acc_name, String email, String mbl, String pswd) async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    String ctryCode = '00';
    String address = 'null';
    String city = 'null';
    String postal_code = 'null';
    try {
      ctryCode = Helper.getCountryCode(myAdress!.country!);
    } catch (e) {
      //print(e.toString());
    }
    try {
      address =
          '${myAdress!.street} , ${myAdress!.subLocality}, ${myAdress!.postalCode}, ${myAdress!.country}';
    } catch (e) {
      //print(e.toString());
    }
    try {
      city = myAdress!.locality!;
    } catch (e) {
      //print(e.toString());
    }
    try {
      postal_code = myAdress!.postalCode!;
    } catch (e) {
      //print(e.toString());
    }

    //print('data...  $pos');
    final parameters = {
      'type': Constants.TYPE_CUSTOMER_REGISTER,
      'mobile_no': mbl,
      'username': email,
      'password': pswd,
      'office_name': Constants.OFFICE_NAME,
      'countrycode': ctryCode,
      'address': address,
      'city': city,
      'post_code': postal_code,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final ress = jsonDecode(respose.data);
    print('register, response is..... ${ress}');
    //Helper.Toast(msg, clr)
    if (ress['RESULT'] == "OK") {
      Navigator.pop(context);
      loginUser(email, pswd);
    } else {
      Navigator.pop(context);//animation
      Helper.msgDialog(context, ress['DATA']['msg'], () {
        Navigator.pop(context);//this dialog

      });

    }
  }

  void goNext(res) {

  }
}
