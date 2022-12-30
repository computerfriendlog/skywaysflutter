import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart' as StripLib;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Model/FareEstimation.dart';
import 'package:skywaysflutter/Model/Ride.dart';
import 'package:skywaysflutter/Screens/HomeScreen.dart';
import 'package:skywaysflutter/Screens/RideProcess/PaymentScreen.dart';
import 'package:skywaysflutter/Widgets/CustomButton.dart';
import 'package:skywaysflutter/Widgets/CustomTextField.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';

class BookingConfirmScreen extends StatefulWidget {
  static const routeName = '/BookingConfirmScreen';

  const BookingConfirmScreen({Key? key}) : super(key: key);

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  final restClient = RestClient();
  Ride? ride;
  List<FareEstimation> list_fare_estimations = [];
  int position_selected = 0;
  int position_selected_vehilce_return = 0;
  bool firstTime = true;

  //TODO ride variables
  List<int> list_integers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  int total_passengers = 1;
  int total_passengers_return = 1;
  int total_hand_luggage = 1;
  int total_hand_luggage_return = 1;
  int total_big_luggage = 1;
  int total_big_luggage_return = 1;

  TextEditingController _controller_instructions = TextEditingController();
  TextEditingController _controller_instructions_return =
      TextEditingController();

  TextEditingController _controller_passenger_name = TextEditingController();
  TextEditingController _controller_passenger_email = TextEditingController();
  TextEditingController _controller_passenger_phone = TextEditingController();
  TextEditingController _controller_flight = TextEditingController();
  TextEditingController _controller_flight_return = TextEditingController();

  bool return_ticket = false;

  //TODO ride variables are above
  ///helper variables
  bool open_select_vehicle = false;
  bool open_select_vehicle_retrun = false;

  bool opend_select_big_luggage = false;
  bool opend_select_big_luggage_return = false;
  bool opend_select_hand_luggage = false;
  bool opend_select_hand_luggage_return = false;
  bool opend_select_passenger = false;
  bool opend_select_passenger_return = false;
  bool isPaymentByCash = true;
  bool isNearAirPort = false;
  bool isNearAirPort_return = false;

  ///above are helpers

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller_passenger_name.text = name;
    _controller_passenger_email.text = user_mail;
    _controller_passenger_phone.text = user_phone;
    _controller_flight.text = '';
    _controller_flight_return.text = '';
  }

  @override
  Widget build(BuildContext context) {
    //print('selected position new ...$position_selected     $firstTime}');
    if (firstTime) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      ride = arguments['ride'];
      list_fare_estimations = arguments['list'];
      position_selected = arguments['position'];
      firstTime = false;
      return_ticket = ride!.return_time != null ? true : false;
      position_selected_vehilce_return = position_selected;
      if (ride!.pick_loc.toString().toLowerCase().contains('airport') ||
          ride!.pick_loc.toString().toLowerCase().contains('terminal')) {
        isNearAirPort = true;
      }
      if (ride!.drop_loc.toString().toLowerCase().contains('airport') ||
          ride!.drop_loc.toString().toLowerCase().contains('terminal')) {
        isNearAirPort_return = true;
      }
      //print('ride ${ride!.pick_time}  list ${list_fare_estimations[position_selected].price}   postion  ${position_selected}');
    }
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        //systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        title: Text(
          'Booking Confirmation',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: Center(
        child: SizedBox(
          //padding: const EdgeInsets.only(top: 5),
          width: _width * 0.95,
          //height: _hight*2,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: _width * 0.01,
              ),
              Row(
                children: [
                  Text(
                    'Outbond Fare ',
                    style: HelperWidgets.text_heading_20b(),
                  ),
                  Text(
                    "${list_fare_estimations[0].price!} ${Constants.CURRENCY}",
                    style: HelperWidgets.text_heading_16b_grey(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date and time ',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () async {
                          ride!.pick_date = await Helper.selectDate(context);
                          if (ride!.pick_date != null) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Text(
                              ride!.pick_date != null
                                  ? '${ride!.pick_date!.day}-${ride!.pick_date!.month}-${ride!.pick_date!.year}'
                                  : "Pickup Date",
                              style: HelperWidgets.text_home_time_time_picker(
                                  ride!.pick_date == null)),
                        ),
                      ),
                      SizedBox(
                        width: _width * 0.01,
                      ),
                      InkWell(
                        onTap: () async {
                          ride!.pick_time = await Helper.selectTime(context);
                          if (ride!.pick_time != null) {
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Text(
                              ride!.pick_time != null
                                  ? '${ride!.pick_time!.hour} : ${ride!.pick_time!.minute}'
                                  : "Pickup Time",
                              style: HelperWidgets.text_home_time_time_picker(
                                  ride!.pick_time == null)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.01,
              ),
              Row(
                children: [
                  Text(
                    'Pick up',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.001,
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      ride!.pick_loc!,
                      style: HelperWidgets.text_heading_16_300(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.01,
              ),
              Row(
                children: [
                  Text(
                    'Drop Off',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.001,
              ),
              Row(
                children: [
                  Flexible(
                      child: Text(
                    ride!.drop_loc!,
                    style: HelperWidgets.text_heading_16_300(),
                  )),
                ],
              ),
              SizedBox(
                height: _width * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Distance: ',
                        style: HelperWidgets.text_heading_16bl_300(),
                      ),
                      Text(
                        ride!.distance != null ? ride!.distance! : '',
                        style: HelperWidgets.text_heading_16_300(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Time: ',
                        style: HelperWidgets.text_heading_16bl_300(),
                      ),
                      Text(
                        ride!.duration != null ? ride!.duration! : '',
                        style: HelperWidgets.text_heading_16_300(),
                      ),
                    ],
                  ),
                ],
              ),
              isNearAirPort
                  ? SizedBox(
                      height: _width * 0.02,
                    )
                  : Container(),
              isNearAirPort
                  ? CustomTextField(_width * 0.9, '', 'Flight No.',
                      TextInputType.number, _controller_flight)
                  : Container(),
              SizedBox(
                height: _width * 0.04,
              ),
              Row(
                children: [
                  Text(
                    'Vehicle:-',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    Constants.img_logo,
                    height: _width * 0.2,
                    width: _width * 0.3,
                  ),
                  SizedBox(
                    width: _width * 0.04,
                  ),
                  Text(
                    list_fare_estimations[position_selected].type!,
                    style: HelperWidgets.text_heading_16_300(),
                  )
                ],
              ),
              SizedBox(
                height: _width * 0.04,
              ),
              Row(
                children: [
                  Text(
                    'Change Vehicle:',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                ],
              ),

              ///---------------Select vehicle------------
              Card(
                child: InkWell(
                  onTap: () {
                    open_select_vehicle = !open_select_vehicle;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                                height: 15, width: 15, Constants.img_menu_taxi),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Text(
                              list_fare_estimations[position_selected].type!,
                              maxLines: 1,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                                height: 15, width: 15, Constants.img_profile),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Text(
                              list_fare_estimations[position_selected].seats!,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Image.asset(
                                height: 15, width: 15, Constants.img_bag),
                            SizedBox(
                              width: _width * 0.02,
                            ),
                            Text(
                              list_fare_estimations[position_selected]
                                  .small_luggage!,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Image.asset(
                                height: 15, width: 15, Constants.img_luggage),
                            Text(
                              list_fare_estimations[position_selected].luggage!,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                            SizedBox(
                              width: _width * 0.02,
                            ),
                            Transform.rotate(
                              angle: open_select_vehicle ? -40 * 7.14 / 180 : 0,
                              child: Icon(Constants
                                  .ic_arrow_forword), // -40 degree to move top side
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              open_select_vehicle
                  ? list_fare_estimations.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: list_fare_estimations.length,
                            //physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              //print('image are   ${list_estimations.length}');
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    open_select_vehicle = false;
                                    position_selected = index;
                                    print(
                                        'selected position...$position_selected');
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_menu_taxi),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              list_fare_estimations[index]
                                                  .type!,
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_profile),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              list_fare_estimations[index]
                                                  .seats!,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_bag),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Text(
                                              list_fare_estimations[index]
                                                  .small_luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_luggage),
                                            Text(
                                              list_fare_estimations[index]
                                                  .luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            index == position_selected
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  )
                                                : Container(
                                                    width: 20,
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Center(
                              child: Text(
                          "Data not found",
                          style: HelperWidgets.text_heading_20b(),
                        )))
                  : Container(),

              ///---------------Passengers------------
              Card(
                child: InkWell(
                  onTap: () {
                    opend_select_passenger = !opend_select_passenger;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                                height: 15, width: 15, Constants.img_profile),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Text(
                              '${total_passengers.toString()} Passenger',
                              maxLines: 1,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                          ],
                        ),
                        Transform.rotate(
                          angle: opend_select_passenger ? -40 * 7.14 / 180 : 0,
                          child: Icon(Constants
                              .ic_arrow_forword), // -40 degree to move top side
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              opend_select_passenger
                  ? list_integers.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //itemCount: imagePath_clicked_list.length,
                            itemCount: list_integers.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              //print('image are   ${list_estimations.length}');
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_passenger = false;
                                    total_passengers = list_integers[index];
                                    print(
                                        'selected passengers...$total_passengers');
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_profile),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              "${list_integers[index]} Passenger",
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            index == total_passengers - 1
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  )
                                                : Container(
                                                    width: 20,
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Center(
                              child: Text(
                          "Data not found",
                          style: HelperWidgets.text_heading_20b(),
                        )))
                  : Container(),

              ///---------------hand luggage------------
              Card(
                child: InkWell(
                  onTap: () {
                    opend_select_hand_luggage = !opend_select_hand_luggage;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                                height: 15, width: 15, Constants.img_bag),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Text(
                              '${total_hand_luggage.toString()} Hand luggage',
                              maxLines: 1,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                          ],
                        ),
                        Transform.rotate(
                          angle:
                              opend_select_hand_luggage ? -40 * 7.14 / 180 : 0,
                          child: Icon(Constants
                              .ic_arrow_forword), // -40 degree to move top side
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              opend_select_hand_luggage
                  ? list_integers.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //itemCount: imagePath_clicked_list.length,
                            itemCount: list_integers.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              //print('image are   ${list_estimations.length}');
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_hand_luggage = false;
                                    total_hand_luggage = list_integers[index];
                                    print(
                                        'selected passengers...$total_hand_luggage');
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_bag),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              "${list_integers[index]} Hand luggage",
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            index == total_hand_luggage - 1
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  )
                                                : Container(
                                                    width: 20,
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Center(
                              child: Text(
                          "Data not found",
                          style: HelperWidgets.text_heading_20b(),
                        )))
                  : Container(),

              ///---------------Big luggage------------
              Card(
                child: InkWell(
                  onTap: () {
                    opend_select_big_luggage = !opend_select_big_luggage;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                                height: 15, width: 15, Constants.img_luggage),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Container(
                              color: Colors.grey,
                              width: 1,
                              height: _width * 0.04,
                            ),
                            SizedBox(
                              width: _width * 0.015,
                            ),
                            Text(
                              '${total_big_luggage.toString()} Luggage',
                              maxLines: 1,
                              style: HelperWidgets.text_heading_16_300(),
                            ),
                          ],
                        ),
                        Transform.rotate(
                          angle:
                              opend_select_big_luggage ? -40 * 7.14 / 180 : 0,
                          child: Icon(Constants
                              .ic_arrow_forword), // -40 degree to move top side
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              opend_select_big_luggage
                  ? list_integers.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //itemCount: imagePath_clicked_list.length,
                            itemCount: list_integers.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              //print('image are   ${list_estimations.length}');
                              return Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_big_luggage = false;
                                    total_big_luggage = list_integers[index];
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_luggage),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              "${list_integers[index]} Luggage",
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300_grey(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            index == total_big_luggage - 1
                                                ? const Icon(
                                                    Icons.check_box,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  )
                                                : Container(
                                                    width: 20,
                                                  )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Center(
                              child: Text(
                          "Data not found",
                          style: HelperWidgets.text_heading_20b(),
                        )))
                  : Container(),
              SizedBox(
                height: _width * 0.04,
              ),
              Row(
                children: [
                  Text(
                    'Instructions',
                    style: HelperWidgets.text_heading_16bl_300(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.02,
              ),
              Helper.reasonTextField(_controller_instructions),

              ///=====================RETURN TICKET=====================
              Container(
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Switch(
                            value: return_ticket,
                            onChanged: (v) {
                              return_ticket = v;
                              setState(() {});
                            }),
                        Text(
                          'Return Journey',
                          style: HelperWidgets.text_heading_16bl_300(),
                        ),
                      ],
                    ),
                    return_ticket
                        ? ListView(
                            shrinkWrap: true,
                            //doing here
                            physics: const NeverScrollableScrollPhysics(),

                            ///important
                            children: [
                              SizedBox(
                                height: _width * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Return Fare ',
                                    style: HelperWidgets.text_heading_20b(),
                                  ),
                                  Text(
                                    "${list_fare_estimations[0].price!} ${Constants.CURRENCY}",
                                    style:
                                        HelperWidgets.text_heading_16b_grey(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.01,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date and time ',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          ride!.retrun_date =
                                              await Helper.selectDate(context);
                                          if (ride!.retrun_date != null) {
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
                                              ride!.retrun_date != null
                                                  ? '${ride!.retrun_date!.day}-${ride!.retrun_date!.month}-${ride!.retrun_date!.year}'
                                                  : "Pickup Date",
                                              style: HelperWidgets
                                                  .text_home_time_time_picker(
                                                      ride!.retrun_date ==
                                                          null)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: _width * 0.01,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          ride!.return_time =
                                              await Helper.selectTime(context);
                                          if (ride!.return_time != null) {
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
                                              ride!.return_time != null
                                                  ? '${ride!.return_time!.hour} : ${ride!.return_time!.minute}'
                                                  : "Pickup Time",
                                              style: HelperWidgets
                                                  .text_home_time_time_picker(
                                                      ride!.return_time ==
                                                          null)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Pick up',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.001,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    ride!.drop_loc!,
                                    style: HelperWidgets.text_heading_16_300(),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.01,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Drop Off',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.001,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    ride!.pick_loc!,
                                    style: HelperWidgets.text_heading_16_300(),
                                  )),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.03,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Distance: ',
                                        style: HelperWidgets
                                            .text_heading_16bl_300(),
                                      ),
                                      Text(
                                        ride!.distance != null
                                            ? ride!.distance!
                                            : '',
                                        style:
                                            HelperWidgets.text_heading_16_300(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Time: ',
                                        style: HelperWidgets
                                            .text_heading_16bl_300(),
                                      ),
                                      Text(
                                        ride!.duration != null
                                            ? ride!.duration!
                                            : '',
                                        style:
                                            HelperWidgets.text_heading_16_300(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              isNearAirPort_return
                                  ? SizedBox(
                                      height: _width * 0.02,
                                    )
                                  : Container(),
                              isNearAirPort_return
                                  ? CustomTextField(
                                      _width * 0.9,
                                      '',
                                      'Flight No.',
                                      TextInputType.number,
                                      _controller_flight_return)
                                  : Container(),
                              SizedBox(
                                height: _width * 0.04,
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Vehicle:-',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    Constants.img_logo,
                                    height: _width * 0.2,
                                    width: _width * 0.3,
                                  ),
                                  SizedBox(
                                    width: _width * 0.04,
                                  ),
                                  Text(
                                    list_fare_estimations[
                                            position_selected_vehilce_return]
                                        .type!,
                                    style: HelperWidgets.text_heading_16_300(),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.04,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Change Vehicle:',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                ],
                              ),

                              ///---------------Select return vehicle------------
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    open_select_vehicle_retrun =
                                        !open_select_vehicle_retrun;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_menu_taxi),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              list_fare_estimations[
                                                      position_selected_vehilce_return]
                                                  .type!,
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_profile),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              list_fare_estimations[
                                                      position_selected_vehilce_return]
                                                  .seats!,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_bag),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Text(
                                              list_fare_estimations[
                                                      position_selected_vehilce_return]
                                                  .small_luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_luggage),
                                            Text(
                                              list_fare_estimations[
                                                      position_selected_vehilce_return]
                                                  .luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Transform.rotate(
                                              angle: open_select_vehicle_retrun
                                                  ? -40 * 7.14 / 180
                                                  : 0,
                                              child: Icon(Constants
                                                  .ic_arrow_forword), // -40 degree to move top side
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              open_select_vehicle_retrun
                                  ? list_fare_estimations.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            //itemCount: imagePath_clicked_list.length,
                                            itemCount:
                                                list_fare_estimations.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              //print('image are   ${list_estimations.length}');
                                              return Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    open_select_vehicle_retrun =
                                                        false;
                                                    position_selected_vehilce_return =
                                                        index;
                                                    print(
                                                        'selected position...$position_selected_vehilce_return');
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_menu_taxi),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Text(
                                                              list_fare_estimations[
                                                                      index]
                                                                  .type!,
                                                              maxLines: 1,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_profile),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Text(
                                                              list_fare_estimations[
                                                                      index]
                                                                  .seats!,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_bag),
                                                            SizedBox(
                                                              width:
                                                                  _width * 0.02,
                                                            ),
                                                            Text(
                                                              list_fare_estimations[
                                                                      index]
                                                                  .small_luggage!,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_luggage),
                                                            Text(
                                                              list_fare_estimations[
                                                                      index]
                                                                  .luggage!,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  _width * 0.02,
                                                            ),
                                                            index ==
                                                                    position_selected_vehilce_return
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 20,
                                                                  )
                                                                : Container(
                                                                    width: 20,
                                                                  )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Center(
                                              child: Text(
                                          "Data not found",
                                          style:
                                              HelperWidgets.text_heading_20b(),
                                        )))
                                  : Container(),

                              ///---------------Passengers------------
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_passenger_return =
                                        !opend_select_passenger_return;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_profile),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              '${total_passengers_return.toString()} Passenger',
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: opend_select_passenger_return
                                              ? -40 * 7.14 / 180
                                              : 0,
                                          child: Icon(Constants
                                              .ic_arrow_forword), // -40 degree to move top side
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              opend_select_passenger_return
                                  ? list_integers.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            //itemCount: imagePath_clicked_list.length,
                                            itemCount: list_integers.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              //print('image are   ${list_estimations.length}');
                                              return Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    opend_select_passenger_return =
                                                        false;
                                                    total_passengers_return =
                                                        list_integers[index];
                                                    print(
                                                        'selected passengers...$total_passengers_return');
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_profile),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Text(
                                                              "${list_integers[index]} Passenger",
                                                              maxLines: 1,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            index ==
                                                                    total_passengers_return -
                                                                        1
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 20,
                                                                  )
                                                                : Container(
                                                                    width: 20,
                                                                  )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Center(
                                              child: Text(
                                          "Data not found",
                                          style:
                                              HelperWidgets.text_heading_20b(),
                                        )))
                                  : Container(),

                              ///---------------hand luggage------------
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_hand_luggage_return =
                                        !opend_select_hand_luggage_return;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_bag),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              '${total_hand_luggage_return.toString()} Hand luggage',
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle:
                                              opend_select_hand_luggage_return
                                                  ? -40 * 7.14 / 180
                                                  : 0,
                                          child: Icon(Constants
                                              .ic_arrow_forword), // -40 degree to move top side
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              opend_select_hand_luggage_return
                                  ? list_integers.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            //itemCount: imagePath_clicked_list.length,
                                            itemCount: list_integers.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              //print('image are   ${list_estimations.length}');
                                              return Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    opend_select_hand_luggage_return =
                                                        false;
                                                    total_hand_luggage_return =
                                                        list_integers[index];
                                                    print(
                                                        'selected passengers...$total_hand_luggage_return');
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_bag),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Text(
                                                              "${list_integers[index]} Hand luggage",
                                                              maxLines: 1,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            index ==
                                                                    total_hand_luggage_return -
                                                                        1
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 20,
                                                                  )
                                                                : Container(
                                                                    width: 20,
                                                                  )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Center(
                                              child: Text(
                                          "Data not found",
                                          style:
                                              HelperWidgets.text_heading_20b(),
                                        )))
                                  : Container(),

                              ///---------------Big luggage------------
                              Card(
                                child: InkWell(
                                  onTap: () {
                                    opend_select_big_luggage_return =
                                        !opend_select_big_luggage_return;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_luggage),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Container(
                                              color: Colors.grey,
                                              width: 1,
                                              height: _width * 0.04,
                                            ),
                                            SizedBox(
                                              width: _width * 0.015,
                                            ),
                                            Text(
                                              '${total_big_luggage_return.toString()} Luggage',
                                              maxLines: 1,
                                              style: HelperWidgets
                                                  .text_heading_16_300(),
                                            ),
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: opend_select_big_luggage_return
                                              ? -40 * 7.14 / 180
                                              : 0,
                                          child: Icon(Constants
                                              .ic_arrow_forword), // -40 degree to move top side
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              opend_select_big_luggage_return
                                  ? list_integers.isNotEmpty
                                      ? Expanded(
                                          child: ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            shrinkWrap: true,
                                            //itemCount: imagePath_clicked_list.length,
                                            itemCount: list_integers.length,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (ctx, index) {
                                              //print('image are   ${list_estimations.length}');
                                              return Card(
                                                child: InkWell(
                                                  onTap: () {
                                                    opend_select_big_luggage_return =
                                                        false;
                                                    total_big_luggage_return =
                                                        list_integers[index];
                                                    setState(() {});
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Image.asset(
                                                                height: 15,
                                                                width: 15,
                                                                Constants
                                                                    .img_luggage),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Container(
                                                              color:
                                                                  Colors.grey,
                                                              width: 1,
                                                              height:
                                                                  _width * 0.04,
                                                            ),
                                                            SizedBox(
                                                              width: _width *
                                                                  0.015,
                                                            ),
                                                            Text(
                                                              "${list_integers[index]} Luggage",
                                                              maxLines: 1,
                                                              style: HelperWidgets
                                                                  .text_heading_16_300_grey(),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            index ==
                                                                    total_big_luggage_return -
                                                                        1
                                                                ? const Icon(
                                                                    Icons
                                                                        .check_box,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 20,
                                                                  )
                                                                : Container(
                                                                    width: 20,
                                                                  )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Center(
                                          child: Center(
                                              child: Text(
                                          "Data not found",
                                          style:
                                              HelperWidgets.text_heading_20b(),
                                        )))
                                  : Container(),
                              SizedBox(
                                height: _width * 0.04,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Instructions',
                                    style:
                                        HelperWidgets.text_heading_16bl_300(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _width * 0.02,
                              ),
                              Helper.reasonTextField(
                                  _controller_instructions_return),
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),

              ///=====================PASSENGER DETAILS=====================
              SizedBox(
                height: _width * 0.02,
              ),
              Row(
                children: [
                  Text(
                    'Passenger detail:-',
                    style: HelperWidgets.text_heading_20b(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.02,
              ),
              CustomTextField(_width * 0.9, 'Alixender', 'Name',
                  TextInputType.text, _controller_passenger_name),
              SizedBox(
                height: _width * 0.02,
              ),
              CustomTextField(_width * 0.9, 'abc@example.com', 'Email',
                  TextInputType.emailAddress, _controller_passenger_email),
              SizedBox(
                height: _width * 0.02,
              ),
              CustomTextField(_width * 0.9, '+44 55 51 ***', 'Phone',
                  TextInputType.number, _controller_passenger_phone),
              SizedBox(
                height: _width * 0.02,
              ),
              Row(
                children: [
                  Text(
                    'Payment:-',
                    style: HelperWidgets.text_heading_20b(),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      isPaymentByCash = true;
                      setState(() {});
                    },
                    child: Container(
                      width: _width * 0.35,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: isPaymentByCash
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          border: Border.all(
                              color: Theme.of(context).primaryColor)),
                      child: Center(
                        child: Text(
                          'Cash',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: isPaymentByCash
                                  ? Colors.white
                                  : Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      isPaymentByCash = false;
                      setState(() {});
                    },
                    child: Container(
                      width: _width * 0.35,
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: isPaymentByCash
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          border: Border.all(
                              color: Theme.of(context).primaryColor)),
                      child: Center(
                        child: Text(
                          'Card',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: isPaymentByCash
                                  ? Theme.of(context).primaryColor
                                  : Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: _width * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  'Additional charges may be applicable for any changes in route , waiting time, additional stops, address changes or vehicle changes',
                  style: HelperWidgets.text_heading_16(),
                ),
              ),
              CustomButton('BOOK NOW', _width * 0.5, () async {
                //book ride here....
                if (_controller_passenger_name.text.toString().isEmpty) {
                  Helper.Toast('Passenger name required', Constants.toast_grey);
                } else if (_controller_passenger_email.text
                    .toString()
                    .isEmpty) {
                  Helper.Toast(
                      'Passenger email required', Constants.toast_grey);
                } else if (_controller_passenger_phone.text
                    .toString()
                    .isEmpty) {
                  Helper.Toast(
                      'Passenger phone number required', Constants.toast_grey);
                } else {
                  //OneWay ticket
                  if (isPaymentByCash) {
                    if (return_ticket) {
                      if (ride!.return_time == null) {
                        Helper.Toast(
                            'Return time required', Constants.toast_grey);
                      } else if (ride!.retrun_date == null) {
                        Helper.Toast(
                            'Return date required', Constants.toast_grey);
                      } else {
                        //Return ticket
                        //payment by cash
                        await bookThisRide(false); //one way
                        await bookThisRide(true); //return
                      }
                    } else {
                      //only one way, with payment by cash
                      bookThisRide(false);
                    }
                  } else {
                    // ride!.mobile_no=_controller_passenger_phone.toString();
                    // ride!.email=_controller_passenger_email.text.toString();
                    //  Navigator.pushNamed(context, PaymentScreen.routeName,arguments: {
                    //    'ride',ride,
                    //    'FareEstimation',list_fare_estimations[position_selected],
                    //    'FareEstimation_return',list_fare_estimations[position_selected_vehilce_return],
                    //  });
                    if (return_ticket) {
                      //both rides

                        if (ride!.return_time == null) {
                          Helper.Toast(
                              'Return time required', Constants.toast_grey);
                        } else if (ride!.retrun_date == null) {
                          Helper.Toast(
                              'Return date required', Constants.toast_grey);
                        } else {
                          //Return ticket
                          String? job_id = await bookThisRide(false);
                          String? job_id_return = await bookThisRide(true);
                          if(job_id!=null && job_id_return!=null){
                            double total_fare = double.parse(list_fare_estimations[position_selected].price!)+double.parse(list_fare_estimations[position_selected_vehilce_return].price!);
                            String? paid_token = await payAmmount(total_fare.toString(), Constants.CURRENCY);
                            if(paid_token!=null){
                              //call API amount paid...
                              // TODO transactionInDatabase(list_fare_estimations[position_selected].price!, "$job_id,$job_id_return", paid_token);
                              Helper.msgDialog(context, "Ride booked successfully, See your menu section MyRide for further details", () {
                                Navigator.pop(context);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    HomeScreen.routeName, (Route<dynamic> route) => false);
                              });
                            } else {
                              ///delete these rides having  and job_id_return
                              await deleteRide("$job_id,$job_id_return");  /// if there are 2 rides then send ids like id1,id2 without space
                              Helper.msgDialog(context, "${Constants.someThingWentWrong} Please try again", () => {
                                Navigator.pop(context)
                              });
                            }
                          }else {
                            Helper.Toast(Constants.someThingWentWrong, Constants.toast_red);
                          }
                        }

                    }
                    else {
                      //one trip
                      String? job_id = await bookThisRide(false);
                      if (job_id != null) {
                        //€
                        String? paid_token = await payAmmount(list_fare_estimations[position_selected].price!, 'eur');
                        if(paid_token!=null){
                          //call API ammount paid...
                          // TODO transactionInDatabase(list_fare_estimations[position_selected].price!, job_id, paid_token);
                          Helper.msgDialog(context, "Ride booked successfully, See your menu section MyRide for further details", () {
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreen.routeName, (Route<dynamic> route) => false);
                          });
                        } else {
                          //delete this ride having job_id
                          await deleteRide(job_id);  /// if there are 2 rides then send ids like id1,id2 without space
                          Helper.msgDialog(context, "${Constants.someThingWentWrong} Please try again", () => {
                            Navigator.pop(context)
                          });
                        }
                      } else {
                        Helper.Toast(Constants.someThingWentWrong, Constants.toast_red);
                      }
                    }
                  }
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> bookThisRide(bool isRetrunTicket) async {
    String dis = ride!.distance!.split(' ').first;
    String dur = ride!.duration!.split(' ').first;
    String code =
        await LocalDatabase.getString(LocalDatabase.USER_COUNTRY_CODE);
    print('distance/duration is in integer ..... ${dis}         ${dur}');
    ride!.mobile_no = _controller_passenger_name.text.toString();
    //doing here.............

    final parameters = {
      'type': Constants.TYPE_BOOK_RIDE,
      'name': _controller_passenger_name.text.toString(),
      'countrycode': code,
      'mobile_no': ride!.mobile_no,
      'office_name': Constants.OFFICE_NAME,
      'pickup': isRetrunTicket ? ride!.drop_loc : ride!.pick_loc,
      'destination': isRetrunTicket ? ride!.pick_loc : ride!.drop_loc,
      'job_date': '${isRetrunTicket ? ride!.retrun_date!.year : ride!.pick_date!.year} ${isRetrunTicket ? ride!.retrun_date!.month : ride!.pick_date!.month} ${isRetrunTicket ? ride!.retrun_date!.day : ride!.pick_date!.day}',
      'job_time': isRetrunTicket ? ride!.return_time : ride!.pick_time,
      'vehicle_type': list_fare_estimations[isRetrunTicket
              ? position_selected_vehilce_return
              : position_selected]
          .type,
      'job_type': isPaymentByCash ? 'Cash' : 'Card',
      'note': isRetrunTicket
          ? _controller_instructions_return.text.toString()
          : _controller_instructions.text.toString(),
      'flight_no': isRetrunTicket
          ? _controller_flight_return.text ?? ''
          : _controller_flight.text ?? '',
      'num_of_people': isRetrunTicket
          ? total_passengers_return.toString()
          : total_passengers.toString(),
      'mileage': dis,
      'hours': dur,
      'otherref': '',
      'fare': isRetrunTicket? list_fare_estimations[position_selected_vehilce_return].price:list_fare_estimations[position_selected].price,
      'WChair': 'no',
      'VIA1': ride!.via1 ?? '',
      'VIA2': ride!.via2 ?? '',
      'VIA3': ride!.via3 ?? '',
      'username': _controller_passenger_email.text.toString(),
      'passenger': _controller_passenger_name.text.toString(),
      'email': _controller_passenger_email.text.toString(),
      'hand_luggage': isRetrunTicket
          ? total_hand_luggage_return.toString()
          : total_hand_luggage.toString(),
      'luggage': isRetrunTicket
          ? total_big_luggage_return.toString()
          : total_big_luggage.toString(),
      'customer_id': driver_id
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('fare estimation..., response is..... ${res}');
    if (res['RESULT'] == "OK" &&
        res['DATA']['msg'] == "Booking Successfully.") {
      if(isPaymentByCash){
        Helper.Toast(
            isRetrunTicket ? "Return ${res['DATA']['msg']}" : res['DATA']['msg'],
            Constants.toast_grey);
      }
      return res['DATA']['job_id'].toString();
      LocalDatabase.saveString(
          isRetrunTicket
              ? LocalDatabase.STARTED_RIDE_RETURN
              : LocalDatabase.STARTED_RIDE,
          res['DATA']['job_id']);
    } else {
      return null;
      Helper.Toast(
          isRetrunTicket ? "Return ${res['DATA']['msg']}" : res['DATA']['msg'],
          Constants.toast_grey);
    }
  }

  ///=-=============================online Payment section
  Future<String?> payAmmount(String amount, String currency) async {
    Map<String, dynamic>? intentParams;
    try{
      intentParams = await creatPaymentIntent(amount, currency);
    }catch(e){
      return null;
    }
    if (intentParams != null) {
      try {
        await StripLib.Stripe.instance.initPaymentSheet(
          paymentSheetParameters: StripLib.SetupPaymentSheetParameters(
            googlePay:
                const StripLib.PaymentSheetGooglePay(merchantCountryCode: "pk"),
            //applePay: true,
            //testEbv:true,
            merchantDisplayName: "Sanwal",
            customerId: intentParams['customer'],
            paymentIntentClientSecret: intentParams['client_secret'],
            customerEphemeralKeySecret: intentParams['ephemeralkey'],
          ),
        );
        await StripLib.Stripe.instance.presentPaymentSheet();
        return intentParams['id']; //or id  client_secret
        Helper.Toast('Payment paid successfully', Constants.toast_grey);
      } catch (e) {
        print('displayPaymentSheet:- Exception $e}');
        return null;
      }
    }else{
      return null;
    }

    //print('payment method is ready...${paymentMethod.card}');
  }

  Future<Map<String, dynamic>?> creatPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body_parameters = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      final re = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization':
                'Bearer sk_test_51MKbx2LedsQzFZxXgueayaj7sSp3Dp6rV82rgoydGn93wLPjPNe9zmO8374VvwEkRxRVGtrI1K7asrYhfa1jZLY400fvXLBX3M',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
          body: body_parameters);

      print('payment paid..., response is..... ${re.body}');
      return jsonDecode(re.body);
    } catch (e) {
      print('exception while paying 259    $e');
    }
  }

  void displayPaymentSheet() async {}

  String calculateAmount(String amount) {
    final a = (double.parse(amount)) * 100;
    return a.round().toString();
  }

  Future<void> deleteRide(String job_ids) async{
    final parameters = {
      'type': Constants.TYPE_DELETE_RIDE,
      'job_id': job_ids,
      'office_name': Constants.OFFICE_NAME,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final ress = jsonDecode(respose.data);
    print('ride delete, response is..... ${ress}');
    if(ress['RESULT']=='OK' && ress['DATA']['msg'].toString().toLowerCase().contains('Deleted Successfully')){
      LocalDatabase.saveString(LocalDatabase.STARTED_RIDE, "null");
      if(job_ids.contains(',')){
        // 2nd jobs deleted
        LocalDatabase.saveString(LocalDatabase.STARTED_RIDE_RETURN, "null");
      }
    }
  }

  Future<void> transactionInDatabase(String amound,String jobIds,String strip_token) async{
    final parameters = {
      'type': Constants.TYPE_STRIPE_PAYMENT_TRANSECTION,
      'amount': amound,
      'office_name': Constants.OFFICE_NAME,
      'job_id': jobIds, ///both ids if available
      'stripeToken': strip_token,
      'email': _controller_passenger_email.text.toString(),
      'description': jobIds.contains(',')? jobIds.split(',').first:jobIds,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final ress = jsonDecode(respose.data);
    if(ress["RESULT"]=="OK" && ress['status']==1){

    } else {

    }
    print('ride Payment transaction, response is..... ${ress}');
  }

  ///==========--------------============------------------Online payment
}
