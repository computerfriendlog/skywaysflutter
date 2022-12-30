import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Helper/LocalDatabase.dart';
import 'package:skywaysflutter/Model/FareEstimation.dart';
import 'package:skywaysflutter/Model/PaymentCard.dart';
import 'package:skywaysflutter/Model/Ride.dart';
import 'package:skywaysflutter/Screens/AddPaymentCardScreen.dart';
import 'package:skywaysflutter/Screens/HomeScreen.dart';
import 'package:skywaysflutter/Widgets/CustomButton.dart';
import 'package:skywaysflutter/Widgets/CustomTextField.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as StripLib;
import 'package:http/http.dart'as http;

class PaymentScreen extends StatefulWidget {
  static const routeName = '/PaymentScreen';

  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final restClient = RestClient();
  List<PaymentCard> list_card = [];
  String publisherKey = 'pk_live_SeOP8P91VXk3mUfkY1G23kVs00jCRrrid0';
  //FareEstimation? fareEstimation;
  //FareEstimation? fareEstimation_return;
  //Ride? ride;
  bool firstTime=true;
  //StripLib.Stripe.String PublicKeyCredential='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPreviousCards();
  }

  @override
  Widget build(BuildContext context) {
    // if (firstTime) {
    //   final arguments =
    //   ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //   ride = arguments['ride'];
    //   fareEstimation=arguments['fareEstimation'];
    //   fareEstimation_return=arguments['fareEstimation_return'];
    //   firstTime=false;
    // }
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Payment',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: SizedBox(
        height: _hight,
        width: _width,
        child: Stack(
          children: [
            SizedBox(
              height: _hight,
              width: _width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(_width * 0.07),
                        child: FloatingActionButton(
                          onPressed: () async {
                            final resut = await Navigator.pushNamed(
                                context, AddPaymentCardScreen.routeName);
                            print('reslt call is  $resut');
                            try {
                              if (resut as bool) {
                                loadPreviousCards();
                              }
                            } catch (e) {}
                          },
                          child: Icon(Constants.ic_add),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            list_card.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: list_card.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Card(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  payAmmount('500.0', 'pkr');
                                },
                                child: SizedBox(
                                  width: _width * 0.7,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Card Number",
                                            style: HelperWidgets
                                                .text_heading_16bl_300(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: _width * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "***********${list_card[index].cardnumber![list_card[index].cardnumber!.length - 3]}${list_card[index].cardnumber![list_card[index].cardnumber!.length - 2]}${list_card[index].cardnumber![list_card[index].cardnumber!.length - 1]}",
                                            style:
                                                HelperWidgets.text_heading_16(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: _width * 0.02,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            list_card[index]
                                                .cardtype
                                                .toString(),
                                            style: HelperWidgets
                                                .text_heading_16_300_grey(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    deleteCard(list_card[index].card_id!,
                                        list_card[index].cardnumber!);
                                  },
                                  child: SizedBox(
                                      width: _width * 0.15,
                                      child: Icon(
                                        Constants.ic_delete,
                                        size: 30,
                                        color: Colors.grey,
                                      )))
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('Cards not found')),
          ],
        ),
      ),
    );
  }

  void loadPreviousCards() async {
    final parameters = {
      'type': Constants.TYPE_CARDS_LIST,
      'office_name': Constants.OFFICE_NAME,
      'customer_id': driver_id
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('card data..., response is..... ${res}');
    list_card.clear();
    if (res['RESULT'] == "OK") {
      res['DATA'].forEach((v) {
        list_card.add(PaymentCard.fromJson(v));
      });
      print('card data..., list_card lengh..... ${list_card.length}');
      setState(() {});
    }
  }

  void deleteCard(String card_id, String card_no) async {
    final parameters = {
      'type': Constants.TYPE_CARDS_DELETE,
      'card_id': Constants.OFFICE_NAME,
      'cardnumber': Constants.OFFICE_NAME,
      'office_name': Constants.OFFICE_NAME,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('card deleting..., response is..... ${res}');
    if (res['RESULT'] == "OK" && res['message'] == "success") {
      Helper.Toast(
          "Your instructions executed successfully", Constants.toast_grey);
      loadPreviousCards();
    } else {
      Helper.Toast(Constants.someThingWentWrong, Constants.toast_grey);
    }
  }

  Future<void> payAmmount(String amount, String currency) async {
    Map<String, dynamic>? intentParams;
    intentParams = await creatPaymentIntent(amount, currency);
    if (intentParams != null) {
      await StripLib.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: StripLib.SetupPaymentSheetParameters(
          googlePay: const StripLib.PaymentSheetGooglePay(merchantCountryCode: "pk"),
          //applePay: true,
          //testEbv:true,
          merchantDisplayName: "Sanwal",
          customerId: intentParams['customer'],
          paymentIntentClientSecret: intentParams['client_secret'],
          customerEphemeralKeySecret: intentParams['ephemeralkey'],

        ),
      );
      displayPaymentSheet();
    }

    //print('payment method is ready...${paymentMethod.card}');
  }

  Future<Map<String, dynamic>?> creatPaymentIntent(String amount, String currency) async{
    try{
      Map<String,dynamic> body_parameters={
        'amount': calculateAmount(amount),
        'currency':currency,
        'payment_method_types[]':'card',
      };

    /*  final respose = await restClient.post('https://api.stripe.com/v1/payment_intents' ,
          headers: {
        'Authorization':'Bearer sk_test_51MKbx2LedsQzFZxXgueayaj7sSp3Dp6rV82rgoydGn93wLPjPNe9zmO8374VvwEkRxRVGtrI1K7asrYhfa1jZLY400fvXLBX3M',
            'Content-Type':'application/x-www-form-urlencoded'
          }, body: body_parameters);*/

      final re=await http.post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':'Bearer sk_test_51MKbx2LedsQzFZxXgueayaj7sSp3Dp6rV82rgoydGn93wLPjPNe9zmO8374VvwEkRxRVGtrI1K7asrYhfa1jZLY400fvXLBX3M',
        'Content-Type':'application/x-www-form-urlencoded'
      },body: body_parameters);

      print('payment paid..., response is..... ${re.body}');
      return jsonDecode(re.body);
    }catch(e){
      print('exception while paying 259    $e');
    }


  }

  void displayPaymentSheet() async {
    try {
      await StripLib.Stripe.instance.presentPaymentSheet();
      Helper.Toast('Payment paid successfully', Constants.toast_grey);
    } catch (e) {
      print('displayPaymentSheet:- Exception $e}');
    }
  }

  String calculateAmount(String amount) {
    final a=(double.parse(amount))*100;
    return a.round().toString();
  }

/*  Future<void> bookThisRide(bool isRetrunTicket) async {
    String dis = ride!.distance!.split(' ').first;
    String dur = ride!.duration!.split(' ').first;
    String code = await LocalDatabase.getString(LocalDatabase.USER_COUNTRY_CODE);
    print('distance/duration is in integer ..... ${dis}         ${dur}');

    final parameters = {
      'type': Constants.TYPE_BOOK_RIDE,
      'name': _controller_passenger_name.text.toString(),
      'countrycode': code,
      'mobile_no': _controller_passenger_phone.text.toString(),
      'office_name': Constants.OFFICE_NAME,
      'pickup': isRetrunTicket? ride!.drop_loc :ride!.pick_loc,
      'destination': isRetrunTicket? ride!.pick_loc : ride!.drop_loc,
      'job_date': '${isRetrunTicket? ride!.retrun_date!.year : ride!.pick_date!.year} ${isRetrunTicket? ride!.retrun_date!.month :ride!.pick_date!.month} ${isRetrunTicket? ride!.retrun_date!.day : ride!.pick_date!.day}',
      'job_time': isRetrunTicket? ride!.return_time:ride!.pick_time,
      'vehicle_type': list_fare_estimations[isRetrunTicket? position_selected_vehilce_return: position_selected].type,
      'job_type': isPaymentByCash ? 'Cash' : 'Card',
      'note': isRetrunTicket ? _controller_instructions_return.text.toString():_controller_instructions.text.toString(),
      'flight_no': isRetrunTicket ? _controller_flight_return.text ?? '': _controller_flight.text ?? '',
      'num_of_people': isRetrunTicket ? total_passengers_return.toString():total_passengers.toString(),
      'mileage': dis,
      'hours': dur,
      'otherref': '',
      'fare': list_fare_estimations[isRetrunTicket?position_selected_vehilce_return:position_selected].price,
      'WChair': 'no',
      'VIA1': ride!.via1 ?? '',
      'VIA2': ride!.via2 ?? '',
      'VIA3': ride!.via3 ?? '',
      'username': _controller_passenger_email.text.toString(),
      'passenger': _controller_passenger_name.text.toString(),
      'email': _controller_passenger_email.text.toString(),
      'hand_luggage': isRetrunTicket? total_hand_luggage_return.toString():total_hand_luggage.toString(),
      'luggage': isRetrunTicket?total_big_luggage_return.toString():total_big_luggage.toString(),
      'customer_id': driver_id
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('fare estimation..., response is..... ${res}');
    if (res['RESULT'] == "OK" && res['DATA']['msg'] == "Booking Successfully.") {
      Helper.Toast(isRetrunTicket? "Return ${res['DATA']['msg']}":res['DATA']['msg'], Constants.toast_grey);

      LocalDatabase.saveString(isRetrunTicket?LocalDatabase.STARTED_RIDE_RETURN:LocalDatabase.STARTED_RIDE, res['DATA']['job_id']);
    } else {
      Helper.Toast(isRetrunTicket? "Return ${res['DATA']['msg']}":res['DATA']['msg'], Constants.toast_grey);
    }
  }*/
}


//https://www.youtube.com/watch?v=QDji61b1loA