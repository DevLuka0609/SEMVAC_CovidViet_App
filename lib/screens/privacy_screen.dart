import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/color.dart';

import '../widget/appbar.dart';

class TCScreen extends StatefulWidget {
  @override
  _TCScreenState createState() => _TCScreenState();
}

class _TCScreenState extends State<TCScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: Text(
        "Welcome to our SEMVAC app. These are our terms and conditions for use of the network, which you may access in serveral ways, including but not limited to the World Wide App via semvac.com, SEMVAC Vietnam Covid Article App. ",
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    );
  }
}
