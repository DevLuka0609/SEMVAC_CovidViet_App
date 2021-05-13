import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/api.dart';
import '../widget/loading.dart';
import '../config/color.dart';
import '../model/article_model.dart';
import '../config/config.dart';
import '../widget/appbar.dart';

class ArticleScreenById extends StatefulWidget {
  final String id;
  ArticleScreenById({Key key, @required this.id}) : super(key: key);
  @override
  _ArticleScreenByIdState createState() => _ArticleScreenByIdState();
}

class _ArticleScreenByIdState extends State<ArticleScreenById> {
  Service _service = new Service();
  Future<Article> _getArticleById;

  @override
  void initState() {
    _getArticleById = getArticleById(widget.id);
    super.initState();
  }

  Future<Article> getArticleById(id) async {
    var result = await _service.getArticleById(id);
    return result;
  }

  Widget body(data) {
    var mq = MediaQuery.of(context).size;
    return Stack(
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
                      for (var i = 0; i < data.images.length; i++)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageBaseUrl + data.images[i],
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
                            data.articleTitle,
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
                            text: data.articleDescription,
                          ),
                        ),
                      ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: appBackground,
      appBar: appBar(context),
      body: LayoutBuilder(
        builder: (context, constraint) {
          return FractionallySizedBox(
            widthFactor: 1.0,
            child: FutureBuilder<Article>(
              future: _getArticleById,
              builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: mq.height * 0.1,
                            ),
                            kLoadingWidget(context),
                          ],
                        ),
                      ),
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError || snapshot.data == null) {
                      return Container(
                        color: Colors.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: mq.height * 0.1,
                              ),
                              kLoadingWidget(context),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return body(snapshot.data);
                    }
                }
              },
            ),
          );
        },
      ),
    );
  }
}
