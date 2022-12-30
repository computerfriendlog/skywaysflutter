import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:skywaysflutter/APIs/RestClient.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Screens/HomeScreen.dart';
import 'package:skywaysflutter/Widgets/CustomButton.dart';
import 'package:skywaysflutter/Widgets/CustomTextField.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';

class AddPaymentCardScreen extends StatefulWidget {
  static const routeName = '/AddPaymentCardScreen';

  const AddPaymentCardScreen({Key? key}) : super(key: key);

  @override
  State<AddPaymentCardScreen> createState() => _AddPaymentCardScreenState();
}

class _AddPaymentCardScreenState extends State<AddPaymentCardScreen> {
  TextEditingController _controller_car_no = TextEditingController();
  TextEditingController _controller_car_cvv = TextEditingController();
  DateTime? expiryDate;
  final restClient = RestClient();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                //width: _width * 0.6
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        height: 30,
                        width: 30,
                        'assets/images/ic_confirmation.png'),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Add card',
                        style: TextStyle(
                            color: Colors.white,
                            //Theme.of(context).cardColor
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      height: _width * 0.05,
                    ),
                    CustomTextField(
                      _width * 0.8,
                      'XXXX XXXX XXXX XXXX',
                      'Card no',
                      TextInputType.number,
                      _controller_car_no,
                      max_length: 16,
                    ),
                    SizedBox(
                      height: _width * 0.05,
                    ),
                    CustomTextField(_width * 0.8, 'XXX', 'CVC',
                        TextInputType.number, _controller_car_cvv,
                        max_length: 3),
                    SizedBox(
                      height: _width * 0.05,
                    ),
                    SizedBox(
                      width: _width * 0.8,
                      child: InkWell(
                        onTap: () async {
                          expiryDate = await Helper.selectDate(context);
                          setState(() {});
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                          child: Center(
                            child: Text(
                                expiryDate != null
                                    ? '${expiryDate!.month}/${expiryDate!.year}'
                                    : "XX/XX",
                                style: HelperWidgets.text_home_time_time_picker(
                                    expiryDate == null)),
                          ),
                        ),
                      ),
                    ),
                    CustomButton('Add', _width * 0.9, () {
                      int sm = 0;
                      print('ddddddddddd   $sm  ');
                      try {
                        for (int i = 0;
                            i < _controller_car_no.text.length;
                            i++) {
                          sm = sm + int.parse(_controller_car_no.text[i]);
                        }
                        print('ggggggggggg   $sm');
                        if (sm % 10 == 0) {
                          String cardType = GetCreditCardType(
                              _controller_car_no.text.toString());
                          addNewCard(
                              _controller_car_no.text.toString(),
                              expiryDate!.month.toString(),
                              expiryDate!.year.toString(),
                              _controller_car_cvv.text.toString(),
                              cardType);
                        } else {
                          Helper.Toast("Invalid card", Constants.grey);
                        }
                      } catch (e) {
                        Helper.Toast("Invalid card", Constants.grey);
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addNewCard(String card_no, String ex_mnt, String ex_year, String cvc,
      String cardType) async {
    final parameters = {
      'type': Constants.TYPE_CARDS_INSERT,
      'customer_id': driver_id,
      'cardnumber': card_no,
      'exp_month': ex_mnt,
      'exp_year': ex_year,
      'cvc': cvc,
      'cardtype': cardType,
      'office_name': Constants.OFFICE_NAME,
    };

    final respose = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    //Navigator.of(context, rootNavigator: true).pop(false);
    final res = jsonDecode(respose.data);
    print('card added..., response is..... ${res}');
    if (res['RESULT'] == "OK" && res['DATA'] == "New_Card_Inserted") {
      Helper.Toast('New Card inserted', Constants.toast_grey);
      Navigator.pop(context,true);
    } else {
      Helper.Toast('Card can\'t insert, try again', Constants.toast_grey);
    }
  }

  String GetCreditCardType(String CreditCardNumber) {
    RegExp regVisa = RegExp("^4[0-9]{12}(?:[0-9]{3})?\$");
    RegExp regMaster = RegExp("^5[1-5][0-9]{14}\$");
    RegExp regExpress = RegExp("^3[47][0-9]{13}\$");
    RegExp regDiners = RegExp("^3(?:0[0-5]|[68][0-9])[0-9]{11}\$");
    RegExp regDiscover = RegExp("^6(?:011|5[0-9]{2})[0-9]{12}\$");
    RegExp regJCB = RegExp("^(?:2131|1800|35\\d{3})\\d{11}\$");

    if (regVisa.hasMatch(CreditCardNumber))
      return "VISA";
    else if (regMaster.hasMatch(CreditCardNumber))
      return "MASTER";
    else if (regExpress.hasMatch(CreditCardNumber))
      return "AEXPRESS";
    else if (regDiners.hasMatch(CreditCardNumber))
      return "DINERS";
    else if (regDiscover.hasMatch(CreditCardNumber))
      return "DISCOVERS";
    else if (regJCB.hasMatch(CreditCardNumber))
      return "JCB";
    else
      return "invalid";
  }
}
