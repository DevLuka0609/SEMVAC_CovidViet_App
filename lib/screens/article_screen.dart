import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/color.dart';
import '../model/article_model.dart';
import '../config/config.dart';
import '../widget/appbar.dart';

class ArticleScreen extends StatefulWidget {
  final Article item;
  ArticleScreen({Key key, @required this.item}) : super(key: key);
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    // final badgeData = Provider.of<BadgeCounter>(context);
    // final badgeCounts = badgeData.count;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: Stack(
        children: [
          Card(
            margin: EdgeInsets.all(8),
            color: articleBackground,
            borderOnForeground: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 2,
                color: Colors.white,
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          // color: cardBorderColor,
                          ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: ImageSlideshow(
                      width: double.infinity,
                      // height: 200,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      children: [
                        for (var i = 0; i < widget.item.images.length; i++)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageBaseUrl + widget.item.images[i],
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                      onPageChanged: (value) {
                        // print('Page changed: $value');
                      },
                      // autoPlayInterval: 4000,
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 10),
                            child: Text(
                              widget.item.articleTitle,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: titleColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // height: mq.height * 0.5,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20, left: 20, right: 10, bottom: 10),
                            child: Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(
                                    link.url,
                                    forceSafariVC: true,
                                  );
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              text: widget.item.articleDescription,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: mq.width * 0.07,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.favorite_outline,
                    color: Colors.white70,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.share_outlined,
                    color: Colors.white70,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
