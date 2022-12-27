import 'dart:async';
import 'dart:convert';
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
import 'package:skywaysflutter/Model/Ride.dart';
import 'package:skywaysflutter/Provider/PlaceSuggestionProvider.dart';
import 'package:skywaysflutter/Screens/LoginScreen.dart';
import 'package:skywaysflutter/Screens/ProfileScreen.dart';
import 'package:skywaysflutter/Screens/SelectVehicleScreen.dart';
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

  /// RIDE DATA BELOW ///
  TextEditingController _controller_pick_up = TextEditingController();
  TextEditingController _controller_drop_off = TextEditingController();
  LatLng? latLng_pick;
  LatLng? latLng_drop;
  DateTime? date_ride;
  DateTime? date_ride_return;
  TimeOfDay? time_ride;
  TimeOfDay? time_ride_return;
  String? distance;
  String? duration;
  bool has_retrun_ticket = false;
  bool show_quote_button = false;

  /// RIDE DATA ABOVE///
  double CAMERA_ZOOM = 15.4746;

  bool selectingPickup = true;
  static CameraPosition? _cameraPosition = CameraPosition(
    target: LatLng(37.121212, 76.65151),
    zoom: 12.4746,
  );
  GoogleMapController? _controller_map;
  Set<Marker> markers = {};
  Set<Polyline> _polyline = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitailData();
    getLocation();
    _controller_pick_up.addListener(() {
      selectingPickup = true;
      if (_controller_pick_up.text.toString().length < 15) {
        searchPlace(_controller_pick_up.text.toString());
      } else {
        searchPlace('');
      }
    });
    _controller_drop_off.addListener(() {
      selectingPickup = false;
      if (_controller_drop_off.text.toString().length < 15) {
        searchPlace(_controller_drop_off.text.toString());
      } else {
        searchPlace('');
      }
    });
    //callDirectionSApi('31.476837, 74.372526', '31.470770, 74.367419');
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
          Constants.APP_NAME,
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
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            initialCameraPosition: _cameraPosition!,
            polylines: _polyline,
            // myLocationEnabled: true,
            // myLocationButtonEnabled: true,
            // compassEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller_map = controller;
              print('map create df');
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
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
                    InkWell(
                      onTap: () {
                        //swipe locations here...
                        if (_controller_pick_up.text.toString().isEmpty) {
                          Helper.Toast(
                              'Select pick-up address', Constants.toast_grey);
                        } else if (latLng_pick == null) {
                          Helper.Toast('Select again pick-up address',
                              Constants.toast_grey);
                        } else {
                          swipeLocations();
                        }
                      },
                      child: Image.asset(
                          width: menu_icon_size,
                          height: menu_icon_size,
                          fit: BoxFit.fill,
                          Constants.img_swap),
                    ),
                  ],
                ),
              ),
              PlaceSearchTextField(
                  _width * 0.95, "Drop Off", _controller_drop_off, () {
                _controller_drop_off.clear();
              }),
              SizedBox(
                width: _width * 0.95,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    date_ride =
                                        await Helper.selectDate(context);
                                    if (date_ride != null) {
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                        date_ride != null
                                            ? '${date_ride!.day}-${date_ride!.month}-${date_ride!.year}'
                                            : "Pickup Date",
                                        style: HelperWidgets
                                            .text_home_time_time_picker(
                                                date_ride == null)),
                                  ),
                                ),
                                SizedBox(
                                  width: _width * 0.01,
                                ),
                                InkWell(
                                  onTap: () async {
                                    time_ride =
                                        await Helper.selectTime(context);
                                    if (time_ride != null) {
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Text(
                                        time_ride != null
                                            ? '${time_ride!.hour} : ${time_ride!.minute}'
                                            : "Pickup Time",
                                        style: HelperWidgets
                                            .text_home_time_time_picker(
                                                time_ride == null)),
                                  ),
                                ),
                              ],
                            ),
                            has_retrun_ticket
                                ? SizedBox(
                                    height: _width * 0.01,
                                  )
                                : Container(),
                            has_retrun_ticket
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          date_ride_return =
                                              await Helper.selectDate(context);
                                          if (date_ride_return != null) {
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: Text(
                                              date_ride_return != null
                                                  ? '${date_ride_return!.day}-${date_ride_return!.month}-${date_ride_return!.year}'
                                                  : "Return Date",
                                              style: HelperWidgets
                                                  .text_home_time_time_picker(
                                                      date_ride_return ==
                                                          null)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: _width * 0.01,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          time_ride_return =
                                              await Helper.selectTime(context);
                                          if (time_ride_return != null) {
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5))),
                                          child: Text(
                                              time_ride_return != null
                                                  ? '${time_ride_return!.hour} : ${time_ride_return!.minute}'
                                                  : "Return Time",
                                              style: HelperWidgets
                                                  .text_home_time_time_picker(
                                                      time_ride_return ==
                                                          null)),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            has_retrun_ticket = !has_retrun_ticket;
                            setState(() {});
                          },
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Text(
                                    'Return?',
                                    style:
                                        HelperWidgets.text_heading_16b_grey(),
                                  ),
                                  Icon(
                                    Icons.keyboard_return,
                                    color: Colors.grey,
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                    SizedBox(
                      width: _width * 0.05,
                    ),
                    show_quote_button
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton.extended(
                                onPressed: () {
                                  if (_controller_pick_up.text
                                      .toString()
                                      .trim()
                                      .isEmpty) {
                                    Helper.Toast(
                                        'Please select valid pick point',
                                        Constants.toast_grey);
                                  } else if (_controller_drop_off.text
                                      .toString()
                                      .trim()
                                      .isEmpty) {
                                    Helper.Toast(
                                        'Please select valid drop-off point',
                                        Constants.toast_grey);
                                  } else if (latLng_pick == null) {
                                    Helper.Toast(
                                        'Please select valid pick point',
                                        Constants.toast_grey);
                                  } else if (latLng_drop == null) {
                                    Helper.Toast(
                                        'Please select valid drop-off point',
                                        Constants.toast_grey);
                                  } else if (time_ride == null) {
                                    Helper.Toast('Please select Pick-up time',
                                        Constants.toast_grey);
                                  } else if (date_ride == null) {
                                    Helper.Toast('Please select drop-off date',
                                        Constants.toast_grey);
                                  } else {
                                    //go to next...
                                    Ride ride = Ride(
                                        distance: distance,
                                        duration: duration,
                                        lat_pick: latLng_pick!.latitude.toString(),
                                        long_pick: latLng_pick!.longitude.toString(),
                                        lat_drop: latLng_drop!.latitude.toString(),
                                        long_drop: latLng_drop!.longitude.toString(),
                                        pick_loc: _controller_pick_up.text.toString(),
                                        drop_loc: _controller_drop_off.text.toString(),
                                        pick_date: date_ride!,
                                        pick_time: time_ride!,
                                        retrun_date: date_ride_return,
                                        return_time: time_ride_return);
                                    Navigator.pushNamed(context, SelectVehicleScreen.routeName, arguments: ride );
                                  }
                                },
                                label: Text(
                                  'Quote',
                                  style: HelperWidgets.text_heading_16b_white(),
                                ),
                                icon: Icon(Constants.ic_arrow_forword),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
              Provider.of<PlaceSuggestProvider>(context).getPlaces().isNotEmpty
                  ? SizedBox(
                      width: _width * 0.95,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: Provider.of<PlaceSuggestProvider>(context)
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
                                    LatLng? ltlng =
                                        await Helper.getLatLongFromAddress(
                                            Provider.of<PlaceSuggestProvider>(
                                                    context,
                                                    listen: false)
                                                .getPlaces()[index]);
                                    print('New latlong   $ltlng');
                                    if (ltlng != null) {
                                      //update camera
                                      //doing here
                                      _controller_pick_up.text =
                                          Provider.of<PlaceSuggestProvider>(
                                                  context,
                                                  listen: false)
                                              .getPlaces()[index];
                                      latLng_pick = ltlng;
                                      UpdateCamera(ltlng,
                                          Constants.CURRENT_LOCATION_LABEL);
                                    } else {
                                      Helper.Toast(
                                          "Please search alter location",
                                          Constants.toast_grey);
                                    }
                                  } else {
                                    LatLng? ltlng =
                                        await Helper.getLatLongFromAddress(
                                            Provider.of<PlaceSuggestProvider>(
                                                    context,
                                                    listen: false)
                                                .getPlaces()[index]);
                                    if (ltlng != null) {
                                      _controller_drop_off.text =
                                          Provider.of<PlaceSuggestProvider>(
                                                  context,
                                                  listen: false)
                                              .getPlaces()[index];
                                      //make poliline here and update camera
                                      latLng_drop = ltlng;
                                      if (latLng_pick != null &&
                                          latLng_drop != null) {
                                        callDirectionSApi(
                                            latLng_pick!, latLng_drop!);
                                      } else {
                                        Helper.Toast(
                                            "Please select your locations again",
                                            Constants.toast_grey);
                                      }
                                    } else {
                                      _controller_drop_off.clear();
                                      Helper.Toast(
                                          "Can't get location, try again",
                                          Constants.toast_grey);
                                    }
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
                                          padding: const EdgeInsets.all(2.0),
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
      'input': query == "" ? "" : query + ' Lahore, pk',
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
    // print('my loc is ${Helper.currentPositon.latitude}   ${Helper.currentPositon.latitude}');
    UpdateCamera(
        LatLng(Helper.currentPositon.latitude, Helper.currentPositon.longitude),
        Constants.CURRENT_LOCATION_LABEL);
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

  void UpdateCamera(LatLng latLng, String marker_label) async {
    _cameraPosition = CameraPosition(
      target: latLng,
      zoom: CAMERA_ZOOM,
    );

    _controller_map!
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
    BitmapDescriptor market_icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size.square(20)),
        Constants.img_map_marker);
    markers.clear();
    markers.add(Marker(
      markerId: MarkerId(marker_label),
      icon: market_icon,
      position: latLng,
    ));
  }

  void callDirectionSApi(LatLng origin, LatLng destination) async {
    //print('origin is here....${origin}');
    final parameters = {
      'origin': '${origin.latitude},${origin.longitude}',
      'destination': '${destination.latitude},${destination.longitude}',
      'key': Constants.MAP_API_KEY
    };
    //print('globel key is  $google_map_key_globle');
    final respose = await restClient.get(
        "https://maps.googleapis.com/maps/api/directions/json?",
        headers: {},
        body: parameters);

    //print('Directions are here....${respose.data}');
    if (respose.statusCode == 200) {
      try {
        distance = respose.data['routes'][0]['legs'][0]['distance']['text'];
        duration = respose.data['routes'][0]['legs'][0]['duration']['text'];
        List<LatLng> latLen = [];
        respose.data['routes'][0]['legs'][0]['steps'].forEach((value) {
          latLen.add(LatLng(
              value['start_location']['lat'], value['start_location']['lng']));
        });
        LatLngBounds latLngBounds = LatLngBounds(
            southwest: LatLng(
                respose.data['routes'][0]['bounds']['southwest']['lat'],
                respose.data['routes'][0]['bounds']['southwest']['lng']),
            northeast: LatLng(
                respose.data['routes'][0]['bounds']['northeast']['lat'],
                respose.data['routes'][0]['bounds']['northeast']['lng']));
        print(
            'dis is $distance   duration is $duration       bounds ${latLngBounds.toString()}');

        _polyline.add(Polyline(
          polylineId: PolylineId('1'),
          width: 5,
          points: latLen,
          color: Theme.of(context).primaryColor,
        ));
        BitmapDescriptor market_icon_initial =
            await BitmapDescriptor.fromAssetImage(
                ImageConfiguration(size: Size.square(20)),
                Constants.img_map_marker_initial);
        BitmapDescriptor market_icon_final =
            await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(size: Size.square(20)),
                Constants.img_map_marker_final);
        markers.clear();
        markers.add(Marker(
          markerId: const MarkerId('init'),
          icon: market_icon_initial,
          position: origin,
        ));
        markers.add(Marker(
          markerId: const MarkerId('Final'),
          icon: market_icon_final,
          position: destination,
        ));
        _controller_map!.animateCamera(
            CameraUpdate.newLatLngBounds(latLngBounds, CAMERA_ZOOM));
        BitmapDescriptor mid_icon = await Helper.createCustomMarkerBitmap(
            '$distance | $duration', context);
        //LatLng latLng_mid=Helper.getMidPointBetweenPoints(latLng_pick!,latLng_drop!);
        print('custom icon is   ${mid_icon.toJson()}');
        LatLng latLng_mid;
        latLng_mid = latLen[latLen.length ~/ 2];
        markers.add(Marker(
          markerId: const MarkerId('mid'),
          icon: mid_icon,
          //icon: market_icon_final,
          position: latLng_mid,
        ));
        show_quote_button = true;
        setState(() {});
      } catch (e) {
        Helper.Toast(Constants.someThingWentWrong + '${e.toString()}',
            Constants.toast_grey);
      }
    } else {
      Helper.Toast(Constants.someThingWentWrong, Constants.toast_red);
    }
  }

  void swipeLocations() {
    String temp = '';
    temp = _controller_pick_up.text.toString();
    _controller_pick_up.text = _controller_drop_off.text.toString().trim();
    _controller_drop_off.text = temp;
    LatLng latLng_temp = latLng_pick!;
    latLng_pick = latLng_drop;
    latLng_drop = latLng_temp;
    if (latLng_pick != null && latLng_drop != null) {
      callDirectionSApi(latLng_pick!, latLng_drop!);
    } else if (latLng_pick != null &&
        _controller_pick_up.text.toString().isNotEmpty) {
      UpdateCamera(latLng_pick!, Constants.CURRENT_LOCATION_LABEL);
    }
  }
}

// TODO  for getting fare estimation scree in real skyway, there is SelectVehicleActivity
///------==========================-----==========================
