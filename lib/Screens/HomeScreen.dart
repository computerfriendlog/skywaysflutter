import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String month = ' . . '; // don't change these values
String day = ' . . ';
String date = ' . . ';

String deviceType = '';
String name = '';
String officeName = '';
String gard_id = '';
String password = '';
String office_phone = '';
String threat_level = '';

class _HomeScreenState extends State<HomeScreen> {
  //bool availableForJob = true;
  //final restClient = RestClient();
  int total_jobs = 0;
  int total_accepted_jobs = 0;
  int total__new_jobs = 0;
  int total_no_of_hours = 0;
  Color? greyButtons = Colors.grey[200];

  //LocationService locationService=LocationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadInitailData();
    //checkHaveStartedJob(); //then start tracking init
    //round if from notification
    //rountNext();
  }

  @override
  Widget build(BuildContext context) {
    //print('staus value is,,,,,,,,,,,,, ${Provider.of<GuardStatus>(context).getStatus()}');
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Container(
            height: _hight,
            width: _width,
            child: ListView(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                  ],
                ),
              ],
            )),
      ),
    );
  }


  /*void loadInitailData() async {
    name = await LocalDatabase.getString(LocalDatabase.NAME);
    officeName = await LocalDatabase.getString(LocalDatabase.USER_OFFICE);
    gard_id = await LocalDatabase.getString(LocalDatabase.GUARD_ID);
    password = await LocalDatabase.getString(LocalDatabase.USER_PASSWORD);
    office_phone = await LocalDatabase.getString(LocalDatabase.USER_MOBILE);
    threat_level = await LocalDatabase.getString(LocalDatabase.THREAT_LEVEL);

    if (Platform.isAndroid) {
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      deviceType = 'IOS';
    }
    print(
        'after login detail is here  $officeName  \n $gard_id      \n   $password   ');
    Provider.of<GuardStatus>(context, listen: false)
        .changeStatus(await LocalDatabase.isAvailable() ?? false);
    DateTime now = DateTime.now();
    //print('day is ${DateFormat('EEEE').format(now)}');

    month = DateFormat.MMMM().format(now);
    date = DateFormat('dd').format(now);
    day = DateFormat('EEEE').format(now);
    getDashboardData(); //it has setState
    await Helper.determineCurrentPosition();
  }

  void getDashboardData() async {
    try {
      final parameters = {
        'type': Constants.DASHBOARD_TYPE,
        'office_name': officeName,
        'guard_id': gard_id,
        'password': password,
      };

      final respoce = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);
      print(
          'dashboard responce is hereeee.         $respoce   mmmmmmmm  ${respoce.data['DATA'][0]}');

      if (respoce.data['RESULT'] == 'OK' && respoce.data['msg'] == 'success') {
        total_jobs = respoce.data['DATA'][0]['total_jobs'];
        total_accepted_jobs = respoce.data['DATA'][0]['total_accepted_jobs'];
        total__new_jobs = respoce.data['DATA'][0]['total_jobs_new'];
        total_no_of_hours = respoce.data['DATA'][0]['total_no_of_hours'];
      } else {
        print("api not working... " + respoce.data['msg']);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  void sendviaSms() async {
    await Helper.determineCurrentPosition();
    final parameters = {
      'type': Constants.RETURN_LINK,
      'office_name': officeName,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    print('link retrun is here...  $respoce');
    if (respoce.data['msg'] == 'success') {
      Helper.textviaSim(office_phone, respoce.data['DATA']['link']);
    }
  }

  void sendviaSystem() async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    try {
      final parameters = {
        'type': Constants.UPDATE_DRIVER_DOC,
        'office_name': officeName,
        'guard_id': gard_id,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.longitude.toString(),
      };
      final respoce = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      print('location update via system, respoce is here...  $respoce');
      if (respoce.data['msg'] == 'Current Location Updated') {
        Helper.Toast('Location updated', Constants.toast_grey);
      } else {
        Helper.Toast(
            'Can\'t update Location, please try again', Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void loadCheckCallsOfStartedJob(
      String job_id,
      ) async {
    print('etting check points');
    await Helper.determineCurrentPosition();

    final parameters = {
      'type': Constants.CHECK_POINTS,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_id': job_id,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    print(
        'response is here of check calls on home page is here  ${respoce.data} ');
    if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
      respoce.data['DATA'].forEach((value) {
        /*chkPoint_list.add(CheckPoint(
            barcode: respoce.data['DATA'][i]['barcode'],
            check_point_id: respoce.data['DATA'][i]['check_point_id'],
            guard_id: respoce.data['DATA'][i]['guard_id'],
            job_id: respoce.data['DATA'][i]['job_id'],
            name: respoce.data['DATA'][i]['name'],
            status: respoce.data['DATA'][i]['status'],
            time: respoce.data['DATA'][i]['time']));*/

        print('check point 1 is  ${value['status']}');
        if (value['status'] == '0') {
          //its upcoming check point
          print('check point alarm time is  ${value['time']}');
          DateTime tempTimeOfCheckPoint =
          DateFormat("dd-MM-yyyy hh:m:ss").parse(value['time']);

          print(
              'time ${tempTimeOfCheckPoint}, difference of  ${value['check_point_id']} is...   ${tempTimeOfCheckPoint.difference(Helper.getCurrentTime())}');
          if (!tempTimeOfCheckPoint
              .difference(Helper.getCurrentTime())
              .isNegative) {
            //check point is coming...
            localNotificationService.scheduleNotification(
                'Dear user Tap here ',
                'To check your job point',
                tempTimeOfCheckPoint.subtract(Duration(minutes: 15)),
                int.parse(value['check_point_id']));
          }
        }
      });
    }
    //print('check point 1 is  }');
  }

  void checkHaveStartedJob() async {
    //57440 start this job recently
    //await LocalDatabase.saveString(LocalDatabase.STARTED_JOB, '57440');
    String id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);

    print('id is  $id ');
    if (id != 'null') {
      //have start job
      loadCheckCallsOfStartedJob(id);
      Helper.checkJobAndTrack();
    }
  }

  void rountNext() async{
    String nextScreen = await LocalDatabase.getString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION);
    print('nextscreen:  $nextScreen}');
    if (nextScreen == Constants.NEXT_SCREEN_CURRENTJOBS) {
      Navigator.of(context).pushNamed(CurrentJobs.routeName);
    } else if (nextScreen == Constants.NEXT_SCREEN_MESSAGE) {
      Navigator.of(context).pushNamed(MessageScreen.routeName);
    } else {
      //remain here...
    }
    LocalDatabase.saveString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION, Constants.NEXT_SCREEN_HOME);
  }

   */

}
