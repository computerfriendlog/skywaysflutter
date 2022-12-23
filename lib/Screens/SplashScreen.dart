import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Helper/LocalDatabase.dart';
import '../Widgets/CustomButton.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  bool showBtn = false;
  String label = 'Next';
  final restClient = RestClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissionStatus();
    getMapKey();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

    return Scaffold(
      body: SizedBox(
        width: _width,
        height: _hight,
        child: Stack(
          children: [
            Image.asset(
                width: _width,
                height: _hight,
                fit: BoxFit.fill,
                Constants.img_splash_background),
            Center(
              child: Image.asset(
                  width: _width * 0.85,
                  height: _hight * 0.15,
                  fit: BoxFit.fill,
                  Constants.img_logo),
            ),
            showBtn
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomButton(label, _width * 0.9,
                          background: Colors.white, () {
                        checkPermissionStatus();
                      }),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void checkPermissionStatus() async {
    if (await Permission.locationAlways.status != PermissionStatus.granted) {
      Helper.msgDialog(context,
          'Please activate your location service to use this App: Location should be Set as All the time',
          () async {
        Navigator.pop(context);
        await Permission.locationAlways
            .request()
            .then((value) => {print('after request res is here   ${value}')});
        if (await Permission.locationAlways.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    }
    /*else if (await Permission.activityRecognition.status !=
        PermissionStatus.granted) {
      if (Platform.isAndroid) {
        Helper.msgDialog(context,
            'Please allow your physical activity service to use this App: Physical activity service should be Set as All the time',
            () async {
          Navigator.pop(context);
          if (await Permission.activityRecognition.request().isGranted) {
            checkPermissionStatus(); //recursive
          } else {
            showBtn = true;
            setState(() {});
            openAppSettings();
          }
        });
      } else if (Platform.isIOS) {
        Helper.msgDialog(
            context, 'Please allow sensors access to keep good performance.',
            () async {
          Navigator.pop(context);
          if (await Permission.sensors.request().isGranted) {
            checkPermissionStatus(); //recursive
          } else {
            showBtn = true;
            setState(() {});
            openAppSettings();
          }
        });
      }
    } else if (await Permission.camera.status != PermissionStatus.granted) {
      Helper.msgDialog(context, 'Please allow camera to take pictures',
          () async {
        Navigator.pop(context);
        if (await Permission.camera.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    } */
    else if (await Permission.notification.status != PermissionStatus.granted) {
      Helper.msgDialog(
          context, 'Please allow notifications to make it more reliable',
          () async {
        Navigator.pop(context);
        if (await Permission.notification.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    } else {
      //Helper.Toast('all permissions granted...', Constants.toast_grey);
      animationCall();
    }
  }

  void animationCall() {
    Helper.showLoading(context);
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    controller?.forward();
    animation?.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        //Navigator.of(context).pushNamed(LoginScreen.routeName);
        print('checking login......');
        LocalDatabase.isUserLogined().then((value) async {
          print('login.value is...$value');
          Navigator.pop(context);
          if (value) {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          } else {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          }
        });
      }
    });
    controller?.addListener(() {
      setState(() {});
    });
  }

  void getMapKey() async {
    final parameters = {
      'type': Constants.TYPE_GOOGLE_MAP_KEY,
      'office_name': Constants.OFFICE_NAME
    };
    try {
      final respose = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      //Navigator.of(context, rootNavigator: true).pop(false);
      final ress = jsonDecode(respose.data);
      print('gogle map key, response is..... ${ress}');
      if (ress['RESULT'] == "Ok") {
        LocalDatabase.saveString(
            LocalDatabase.GOOGLE_MAP_KEY, ress['DATA']['link']);
        google_map_key_globle = ress['DATA']['link'];
      } else {
        google_map_key_globle =
            await LocalDatabase.getString(LocalDatabase.GOOGLE_MAP_KEY);
      }
    } catch (e) {
      google_map_key_globle = await LocalDatabase.getString(LocalDatabase.GOOGLE_MAP_KEY);
    }
  }
}
