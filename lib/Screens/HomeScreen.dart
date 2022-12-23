import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Provider/PlaceSuggestionProvider.dart';
import 'package:skywaysflutter/Screens/LoginScreen.dart';
import 'package:skywaysflutter/Screens/ProfileScreen.dart';
import 'package:skywaysflutter/Screens/SupportScreen.dart';
import 'package:skywaysflutter/Widgets/CustomButton.dart';
import 'package:skywaysflutter/Widgets/PlaceSearchTextField.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';
import 'package:provider/provider.dart';

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
String driver_id = '';
String password = '';
String driver_phone = '';
String driver_mail = '';
String threat_level = '';
String google_map_key_globle = '';
bool isLogined = false;

class _HomeScreenState extends State<HomeScreen> {
  //bool availableForJob = true;
  //final restClient = RestClient();
  int total_jobs = 0;
  int total_accepted_jobs = 0;
  int total__new_jobs = 0;
  int total_no_of_hours = 0;
  Color? greyButtons = Colors.grey[200];
  double menu_icon_size = 23;
  final restClient = RestClient();
  TextEditingController _controller_pick_up = TextEditingController();
  TextEditingController _controller_drop_off = TextEditingController();
  LatLng? latLng_pick;
  LatLng? latLng_drop;

  bool selectingPickup = true;
  static CameraPosition? _cameraPosition = CameraPosition(
    target: LatLng(37.121212, 76.65151),
    zoom: 12.4746,
  );
  GoogleMapController? _controller_map;
  Set<Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitailData();
    getLocation();
    _controller_pick_up.addListener(() {
      selectingPickup = true;
      if (_controller_pick_up.text.toString().length < 7) {
        searchPlace(_controller_pick_up.text.toString());
      } else {
        searchPlace('');
      }
    });
    _controller_drop_off.addListener(() {
      selectingPickup = false;
      if (_controller_drop_off.text.toString().length < 7) {
        searchPlace(_controller_drop_off.text.toString());
      } else {
        searchPlace('');
      }
    });
  }

  @override
  build(BuildContext context) {
    //print('staus value is,,,,,,,,,,,,, ${Provider.of<GuardStatus>(context).getStatus()}');
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        title: Text(
          'SkyWaysCars',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              //width: _width * 0.4,
              height: _hight * 0.2,
              child: DrawerHeader(
                padding: const EdgeInsets.all(30),
                child: Image.asset(fit: BoxFit.fill, Constants.img_logo),
              ),
            ),
            ListTile(
              leading: Image.asset(
                  width: menu_icon_size,
                  height: menu_icon_size,
                  fit: BoxFit.fill,
                  Constants.img_menu_taxi),
              title: Text(
                'Book Now',
                style: HelperWidgets.text_menu(),
              ),
              iconColor: Colors.grey,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            isLogined
                ? ListTile(
                    leading: Image.asset(
                        width: menu_icon_size,
                        height: menu_icon_size,
                        fit: BoxFit.fill,
                        Constants.img_profile),
                    title: Text('Profile', style: HelperWidgets.text_menu()),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                  )
                : Container(),
            isLogined
                ? ListTile(
                    leading: Image.asset(
                        width: menu_icon_size,
                        height: menu_icon_size,
                        fit: BoxFit.fill,
                        Constants.img_payment),
                    title: Text('Payment', style: HelperWidgets.text_menu()),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  )
                : Container(),
            isLogined
                ? ListTile(
                    leading: Image.asset(
                        width: menu_icon_size,
                        height: menu_icon_size,
                        fit: BoxFit.fill,
                        Constants.img_ride),
                    title: Text('My Rides', style: HelperWidgets.text_menu()),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  )
                : Container(),
            ListTile(
              leading: Image.asset(
                  width: menu_icon_size,
                  height: menu_icon_size,
                  fit: BoxFit.fill,
                  Constants.img_menu_support),
              title: Text('Support', style: HelperWidgets.text_menu()),
              onTap: () {
                Navigator.pushNamed(context, SupportScreen.routeName);
              },
            ),
            isLogined
                ? ListTile(
                    leading: Image.asset(
                        width: menu_icon_size,
                        height: menu_icon_size,
                        fit: BoxFit.fill,
                        Constants.img_logout),
                    title: Text('Logout', style: HelperWidgets.text_menu()),
                    onTap: () async {
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
                                    Navigator.of(context, rootNavigator: true).pop(
                                        false); // dismisses only the dialog and returns false
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true).pop(
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
                          Helper.Toast(
                              'Logout failed, try again', Constants.toast_red);
                        }
                      } else {
                        print('don\'t logout');
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          height: _hight,
          width: _width,
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                markers: markers,
                initialCameraPosition: _cameraPosition!,
                onMapCreated: (GoogleMapController controller) {
                  _controller_map = controller;
                  print('map createdf');
                },
              ),
              ListView(
                children: [
                  Column(
                    //mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PlaceSearchTextField(
                          _width * 0.95, "Pick up", _controller_pick_up, () {
                        _controller_pick_up.clear();
                      }),
                      Container(
                        width: _width * 0.95,
                        margin: const EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                                width: menu_icon_size,
                                height: menu_icon_size,
                                fit: BoxFit.fill,
                                Constants.img_add_circled_plus),
                            Image.asset(
                                width: menu_icon_size,
                                height: menu_icon_size,
                                fit: BoxFit.fill,
                                Constants.img_swap),
                          ],
                        ),
                      ),
                      PlaceSearchTextField(
                          _width * 0.95, "Drop Off", _controller_drop_off, () {
                        _controller_drop_off.clear();
                      }),
                      Provider.of<PlaceSuggestProvider>(context)
                              .getPlaces()
                              .isNotEmpty
                          ? SizedBox(
                              width: _width * 0.95,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                reverse: true,
                                itemCount:
                                    Provider.of<PlaceSuggestProvider>(context)
                                        .getPlaces()
                                        .length,
                                physics: const ScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return Container(
                                    padding: const EdgeInsets.all(1),
                                    child: Card(
                                      child: InkWell(
                                        onTap: () async {
                                          if (selectingPickup) {
                                            _controller_pick_up.text = Provider
                                                    .of<PlaceSuggestProvider>(
                                                        context,
                                                        listen: false)
                                                .getPlaces()[index];
                                          } else {
                                            _controller_drop_off.text = Provider
                                                    .of<PlaceSuggestProvider>(
                                                        context,
                                                        listen: false)
                                                .getPlaces()[index];
                                          }
                                          print('clicked....$selectingPickup');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Constants.ic_location,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    Provider.of<PlaceSuggestProvider>(
                                                            context)
                                                        .getPlaces()[index],
                                                    style: HelperWidgets
                                                        .text_heading_16_300(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadInitailData() async {
    name = await LocalDatabase.getString(LocalDatabase.NAME);
    driver_id = await LocalDatabase.getString(LocalDatabase.DRIVER_ID);
    password = await LocalDatabase.getString(LocalDatabase.USER_PASSWORD);
    driver_phone = await LocalDatabase.getString(LocalDatabase.USER_MOBILE);
    driver_mail = await LocalDatabase.getString(LocalDatabase.USER_EMAIL);
    isLogined = await LocalDatabase.isUserLogined();
    //threat_level = await LocalDatabase.getString(LocalDatabase.THREAT_LEVEL);

    if (Platform.isAndroid) {
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      deviceType = 'IOS';
    }
    setState(() {});
    //await Helper.determineCurrentPosition();
    //setState(() {});
  }

  void searchPlace(String query) async {
    final parameters = {
      'input': query,
      //'key': 'AIzaSyCuVz0BvNOdc0-Y4X9U3bBdEOx6bq6yvHI',//thmovers  //Constants.MAP_API_KEY,
      'key': Constants.MAP_API_KEY,
    };
    final respose = await restClient.get(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?",
        headers: {},
        body: parameters);

    print('place suggestion are here....${respose.data['predictions']}');
    if (respose.data != null) {
      Provider.of<PlaceSuggestProvider>(context, listen: false).removeAll();
      respose.data['predictions'].forEach((prediction) {
        Provider.of<PlaceSuggestProvider>(context, listen: false)
            .add(prediction['description']);
        print('place suggestion are here....${prediction['description']}');
      });
    }
  }

  void getLocation() async {
    await Helper.determineCurrentPosition();
    print(
        'my loc is ${Helper.currentPositon.latitude}   ${Helper.currentPositon.latitude}');
    //_cameraPosition!.target.latitude!=Helper.currentPositon.latitude;
    //_cameraPosition!.target.longitude!=Helper.currentPositon.longitude;
    _cameraPosition = CameraPosition(
      target: LatLng(
          Helper.currentPositon.latitude, Helper.currentPositon.longitude),
      zoom: 15.4746,
    );
    //final GoogleMapController controller = await _controller_map.future;
    BitmapDescriptor market_icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size.square(20)),
        Constants.img_map_marker);
    _controller_map!
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
    markers.add(Marker(
      markerId: MarkerId('Current Location'),
      icon: market_icon,
      position: LatLng(
          Helper.currentPositon.latitude, Helper.currentPositon.longitude),
    ));
    latLng_pick =
        LatLng(Helper.currentPositon.latitude, Helper.currentPositon.longitude);
    if (latLng_pick != null) {
      String pik = await Helper.getAddressFromLatLong(latLng_pick!);
      if (pik != 'null') {
        _controller_pick_up.text = pik;
      }
      setState(() {});
    }
  }
}

// TODO  for getting fare estimation scree in real skyway SelectVehicleActivity
///------==========================-----==========================
