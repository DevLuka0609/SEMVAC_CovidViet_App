import 'package:flutter/material.dart';
import 'package:semvac_covid_viet/screens/home_screen.dart';

import '../config/color.dart';
import '../screens/privacy_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/notification_screen.dart';

Widget appBar(context) => PreferredSize(
      preferredSize: const Size(double.infinity, kToolbarHeight),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: appbarColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Container(
                height: kToolbarHeight,
                padding: EdgeInsets.all(2),
                child: Image.asset(
                  "assets/images/SEMVAC_Logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TCScreen(),
                  ),
                );
              },
              child: Center(
                child: Text(
                  "SEMVAC",
                  style: TextStyle(
                    fontSize: 22,
                    color: appLogoColor,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouriteScreen(),
                ),
              );
            },
            child: Icon(
              Icons.favorite_outline,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
