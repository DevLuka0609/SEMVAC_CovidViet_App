import 'dart:convert' show json;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/badge_provider.dart';
import '../widget/notification_item_widget.dart';
import '../config/color.dart';
import '../widget/appbar.dart';
import '../screens/article_screen_by_id.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map> notificationList = [];

  @override
  void initState() {
    getNotifications();

    super.initState();
  }

  void getNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String prevListStr = prefs.getString('nfList');

    if (prevListStr != null) {
      var prevList = json.decode(prevListStr);
      setState(() {
        notificationList = List<Map>.from(prevList);
      });
    }
  }

  void removeNotificationbyIndex(index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationList.removeAt(index);
      prefs.setString("nfList", json.encode(notificationList));
    });
  }

  void removeAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      notificationList.clear();
      prefs.setString("nfList", json.encode(notificationList));
    });
  }

  Widget body() {
    var mq = MediaQuery.of(context).size;
    final badgeData = Provider.of<BadgeCounter>(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    SizedBox(
                      width: mq.width * 0.3,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                      child: ElevatedButton(
                        child: Text('Clear all'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                        ),
                        onPressed: () {
                          removeAll();
                        },
                      ),
                    ),
                  ],
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
          Expanded(
            flex: 7,
            child: ListView.builder(
              itemCount: notificationList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5, top: 2, right: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleScreenById(
                            id: notificationList[index]['article_id'],
                          ),
                        ),
                      );
                      badgeData.initalizeCount();
                      this.removeNotificationbyIndex(index);
                    },
                    child: NotificationWidget(
                      item: notificationList[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: body(),
    );
  }
}
