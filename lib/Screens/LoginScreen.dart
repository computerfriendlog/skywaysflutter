import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTextField.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/LoginScreen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller_officeName = TextEditingController();
  TextEditingController _controller_UserName = TextEditingController();
  TextEditingController _controller_Password = TextEditingController();
  //final restClient = RestClient();
  bool rememberMe = false;
  bool locked = true;

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
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              width: _width,
              height: _hight,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                              height: _hight * 0.18,
                              "assets/images/ic_top.png"),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                              height: _hight * 0.18,
                              "assets/images/ic_bottom.png"),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                          size: _width * 0.25,
                          color: locked? Colors.black.withOpacity(0.5) : Colors.black,
                          locked
                              ? Icons.lock_outlined
                              : Icons.lock_open_outlined),
                      CustomTextField(
                          _width * 0.95,
                          'Enter office name',
                          'Office name',
                          TextInputType.name,
                          _controller_officeName),
                      CustomTextField(
                          _width * 0.95,
                          'Enter username',
                          'User name',
                          TextInputType.name,
                          _controller_UserName),
                      CustomTextField(
                          _width * 0.95,
                          'Enter password',
                          'Password',
                          TextInputType.visiblePassword,
                          _controller_Password),
                      Row(
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
                                fontSize: 14, fontWeight: FontWeight.w300),
                          )
                        ],
                      ),
                      CustomButton('Login', _width * 0.85, () {
                        Helper.isInternetAvailble().then((value) => {
                              if (value == true)
                                {
                                  if (_controller_officeName.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    {
                                      showToast(
                                        "Invalid Office name",
                                        duration: const Duration(seconds: 1),
                                        position: ToastPosition.top,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        radius: 3.0,
                                        textStyle:
                                            const TextStyle(fontSize: 14.0),
                                      ),
                                    }
                                  else if (_controller_UserName.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    {
                                      showToast(
                                        "Invalid Username",
                                        duration: const Duration(seconds: 1),
                                        position: ToastPosition.top,
                                        backgroundColor:
                                            Colors.black.withOpacity(0.8),
                                        radius: 3.0,
                                        textStyle:
                                            const TextStyle(fontSize: 14.0),
                                      ),
                                    }
                                  else if (_controller_Password.text
                                      .toString()
                                      .trim()
                                      .isEmpty)
                                    {
                                      Helper.Toast("Invalid Password",Constants.toast_red )
                                    }
                                  else
                                    {
                                      //login here
                                      loginUser()
                                    }
                                }
                              else
                                {
                                  Helper.Toast(Constants.noInternetConnection,Constants.toast_red )
                                }
                            });
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Reset password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
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

  loginUser() async {

  }
}
