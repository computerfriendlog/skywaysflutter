import 'package:flutter/material.dart';
import 'package:skywaysflutter/Helper/Constants.dart';
import 'package:skywaysflutter/Helper/Helper.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';

class SupportScreen extends StatefulWidget {
  static const routeName = '/SupportScreen';

  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Support',
          style: HelperWidgets.myAppbarStyle(),
        ),
      ),
      body: SafeArea(
        child: SizedBox(
            height: _hight,
            width: _width,
            child: ListView(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'CUSTOMER SUPPORT HOTLINES',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            )),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Helper.openEmailApp(Constants.SUPPORT_OFFICE_EMAIL);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contact us on E-mail',
                                  style: HelperWidgets.text_heading_16(),
                                ),
                                Image.asset(
                                    height: 30, width: 30, Constants.img_mail)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _hight * .001,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Card(
                        child: InkWell(
                          onTap: () {
                            Helper.openWhatsapp();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contact us on WhatsApp',
                                  style: HelperWidgets.text_heading_16(),
                                ),
                                Image.asset(
                                    height: 30,
                                    width: 30,
                                    Constants.img_whatsapp_logo)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _hight * .001,
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: Card(
                        child: InkWell(
                          onTap: () { Helper.makePhoneCall(
                              Constants.SUPPORT_PHONE_NUMBER);},
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Constants.SUPPORT_PHONE_NUMBER,
                                  style: HelperWidgets.text_heading_16(),
                                ),
                                Image.asset(
                                    height: 30,
                                    width: 30,
                                    Constants.img_call_logo)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: _hight * .001,
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
