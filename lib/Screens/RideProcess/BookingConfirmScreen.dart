import 'package:flutter/material.dart';
import 'package:skywaysflutter/Model/FareEstimation.dart';
import 'package:skywaysflutter/Model/Ride.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';
class BookingConfirmScreen extends StatefulWidget {
  static const routeName = '/BookingConfirmScreen';
  const BookingConfirmScreen({Key? key}) : super(key: key);

  @override
  State<BookingConfirmScreen> createState() => _BookingConfirmScreenState();
}

class _BookingConfirmScreenState extends State<BookingConfirmScreen> {
  Ride? ride;
  List<FareEstimation> list_fare_estimations=[];

  @override
  Widget build(BuildContext context) {
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
      body: SizedBox(
        //padding: const EdgeInsets.only(top: 5),
        width: _width ,
        child: Column(
          children: [
            Row(
              children: [
                Text('Outbond Fare' ,style: HelperWidgets.text_heading_20b(),),
                Text(list_fare_estimations[0].price! ,style: HelperWidgets.text_heading_16b_grey(),),
              ],
            ),

          ],
        ),
      ),
    );

  }
}
