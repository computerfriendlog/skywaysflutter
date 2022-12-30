import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Model/FareEstimation.dart';
import 'package:skywaysflutter/Model/Ride.dart';
import 'package:skywaysflutter/Screens/RideProcess/BookingConfirmScreen.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';

class SelectVehicleScreen extends StatefulWidget {
  static const routeName = '/SelectVehicleScreen';

  const SelectVehicleScreen({Key? key}) : super(key: key);

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  Ride? ride;

  // final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
  final restClient = RestClient();
  bool firstTime = true;
  List<FareEstimation> list_estimations = [];

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      ride = ModalRoute.of(context)!.settings.arguments as Ride?;
      getData();
      firstTime = false;
    }
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        elevation: 0,
        title: Text(
          'Select Vehicle',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: SizedBox(
        //padding: const EdgeInsets.only(top: 5),
        width: _width,
        child: Column(
          children: [
            SizedBox(
              height: _width * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: _width * 0.03,
                ),
                Image.asset(
                    height: 25, width: 25, Constants.img_map_marker_initial),
                Flexible(
                    child: Text(
                  ride!.pick_loc != null ? ride!.pick_loc! : '',
                  style: HelperWidgets.text_heading_16_300(),
                )),
              ],
            ),
            SizedBox(
              height: _width * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: _width * 0.03,
                ),
                Image.asset(
                    height: 25, width: 25, Constants.img_map_marker_final),
                Flexible(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    ride!.drop_loc != null ? ride!.drop_loc! : '',
                    style: HelperWidgets.text_heading_16_300(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: _width * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text( 
                  ride!.distance != null ? 'Distance: ${ride!.distance!}' : '',
                  style: HelperWidgets.text_heading_16b_grey(),
                ),
                Text(
                  ride!.duration != null ? 'Time: ${ride!.duration!}' : '',
                  style: HelperWidgets.text_heading_16b_grey(),
                ),
              ],
            ),
            list_estimations.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      //itemCount: imagePath_clicked_list.length,
                      itemCount: list_estimations.length,
                      physics: const ScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        //print('image are   ${list_estimations.length}');
                        return Container(
                            padding: const EdgeInsets.all(5),
                            //height: 65,
                            width: _width * 0.95,
                            //child: Image.file(File(imagePath_clicked_list[index])));
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: _width * 0.01,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          maxLines: 1,
                                          list_estimations[index].type!,
                                          style: HelperWidgets
                                              .text_heading_16b_grey(),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_profile),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Text(
                                              list_estimations[index].seats!,
                                              style: HelperWidgets
                                                  .text_heading_16(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_bag),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Text(
                                              list_estimations[index]
                                                  .small_luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16(),
                                            ),
                                            SizedBox(
                                              width: _width * 0.02,
                                            ),
                                            Image.asset(
                                                height: 15,
                                                width: 15,
                                                Constants.img_luggage),
                                            Text(
                                              list_estimations[index].luggage!,
                                              style: HelperWidgets
                                                  .text_heading_16(),
                                            ),
                                          ],
                                        ),
                                        /*Image.network(height: _width*0.1,width: _width*0.2,
                                      list_estimations[index].car_image!),*/
                                        Image.asset(
                                            height: _width * 0.2,
                                            width: _width * 0.3,
                                            Constants.img_logo),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: _width * 0.35,
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, BookingConfirmScreen.routeName,
                                                arguments:
                                                {'list':list_estimations,
                                                  'ride':ride,
                                                  'position':index,
                                                },
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                list_estimations[index].orig_price!=null ?Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  "ONE WAY: ${list_estimations[index].orig_price!} ${Constants.CURRENCY}",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ):const Text(' '),
                                                Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  "ONE WAY: ${list_estimations[index].price!} ${Constants.CURRENCY}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: _width * 0.35,
                                          padding: const EdgeInsets.all(7),
                                          decoration: const BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              /// send following all data
                                              //list_estimations
                                              //ride
                                              //position
                                              Navigator.pushNamed(context, BookingConfirmScreen.routeName,
                                                  arguments:
                                                  {'list':list_estimations,
                                                    'ride':ride,
                                                    'position':index,
                                                  },
                                                  );
                                            },
                                            child: Column(
                                              children: [
                                                list_estimations[index].orig_return_fare!=null?Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  "RETURN: ${list_estimations[index].orig_return_fare!} ${Constants.CURRENCY}",
                                                  style: const TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ):const Text(' '),
                                                Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  "RETURN: ${list_estimations[index].return_fare!} ${Constants.CURRENCY}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                      },
                    ),
                  )
                : Center(
                    child: Center(
                        child: Text(
                    "Data not found",
                    style: HelperWidgets.text_heading_20b(),
                  ))),
          ],
        ),
      ),
    );
  }

  getData() async {
    //Helper.showLoading(context);
    String code = await LocalDatabase.getString(LocalDatabase.USER_COUNTRY_CODE);
    String dis = ride!.distance!.split(' ').first;
    final parameters = {
      'type': Constants.TYPE_ALL_VEHICLE_PRICES,
      'office_name': Constants.OFFICE_NAME,
      'miles': dis,
      'currencyCode': code,
      'pickup': ride!.pick_loc,
      'destination': ride!.drop_loc,
      'job_date': '${ride!.pick_date!.year}-${ride!.pick_date!.month}-${ride!.pick_date!.day}', //yyyy-MM-dd
      'job_time': ride!.pick_time,
      'v1': ride!.via1,
      'v2': ride!.via2,
      'v3': ride!.via3,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('fare estimation..., response is..... ${res}');
    if (res['RESULT'] == "OK" && res['status'] == 1) {
      res['DATA'].forEach((value) {
        list_estimations.add(FareEstimation.fromJson(value));
      });
      print(
          '...............${list_estimations[0].car_image}       ${list_estimations.length}');
      setState(() {});
    }
  }
}
