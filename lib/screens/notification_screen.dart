import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/color.dart';

import '../widget/appbar.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
              child: Text(
                "Notification",
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(
              indent: 15,
              endIndent: 15,
              thickness: 2,
              height: 20,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
