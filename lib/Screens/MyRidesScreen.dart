import 'package:flutter/material.dart';
import 'package:skywaysflutter/Widgets/HelperWidgets.dart';
class MyRidesScreen extends StatefulWidget {
  static const routeName = '/MyRidesScreen';
  const MyRidesScreen({Key? key}) : super(key: key);

  @override
  State<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends State<MyRidesScreen> {
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
          'My Bookings',
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

          ]
      ),
      ),
      ),
    );
  }
}
