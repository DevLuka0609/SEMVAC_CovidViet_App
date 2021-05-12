import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:localstorage/localstorage.dart';

import '../service/api.dart';
import '../config/config.dart';
import '../model/article_model.dart';
import '../config/color.dart';

class ArticleItemWidget extends StatefulWidget {
  final Article item;
  ArticleItemWidget({Key key, @required this.item}) : super(key: key);
  @override
  _ArticleItemWidgetState createState() => _ArticleItemWidgetState();
}

class _ArticleItemWidgetState extends State<ArticleItemWidget> {
  bool isFavorite = false;
  Service _service = new Service();
  List<dynamic> favorIds = [];
  final LocalStorage storage = new LocalStorage('favorite_articles');

  @override
  void initState() {
    initStorage();
    super.initState();
  }

  void initStorage() async {
    await storage.ready;
    // storage.clear();
    if (storage.getItem("favorIds") == null) {
      favorIds = [];
      setState(() {
        isFavorite = false;
      });
    } else {
      favorIds = storage.getItem("favorIds");
      for (var i = 0; i < favorIds.length; i++) {
        if (widget.item.id == favorIds[i]) {
          setState(() {
            isFavorite = true;
          });
        }
      }
    }
  }

  void addFavor(context, id) async {
    favorIds =
        storage.getItem("favorIds") == null ? [] : storage.getItem("favorIds");
    if (isFavorite || favorIds.isEmpty) {
      bool isalready = false;
      for (var i = 0; i < favorIds.length; i++) {
        if (id == favorIds[i]) isalready = true;
      }
      if (isalready) return;
      setState(() {
        favorIds.add(id);
      });
      storage.setItem("favorIds", favorIds);
      print(storage.getItem("favorIds"));
      Flushbar flush;
      var result = await _service.addFvorites(id);
      if (result == true) {
        flush = Flushbar<bool>(
            message: "You select the article as your favorites succesfully!",
            margin: EdgeInsets.all(8),
            borderRadius: 8,
            duration: Duration(seconds: 3),
            mainButton: FlatButton(
              onPressed: () {
                flush.dismiss(true); // result = true
              },
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Noto_Sans_JP',
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ) //
            )
          ..show(context);
      }
    } else {
      for (var i = 0; i < favorIds.length; i++) {
        if (id == favorIds[i]) {
          setState(() {
            favorIds.removeAt(i);
          });
          break;
        }
      }
      storage.setItem("favorIds", favorIds);
      print(storage.getItem("favorIds"));
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    Icon iconData = isFavorite
        ? Icon(
            Icons.favorite_outlined,
            color: Colors.white70,
            size: 25,
          )
        : Icon(
            Icons.favorite_border_outlined,
            color: Colors.white70,
            size: 25,
          );
    Widget favoriteIcon = FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return iconData;
      },
    );

    Widget articleItem = Card(
      color: articleBackground,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          width: 1,
          color: cardBorderColor,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(8.0),
            width: mq.width * 0.3,
            height: mq.width * 0.3,
            decoration: BoxDecoration(
              border: Border.all(
                  // color: cardBorderColor,
                  ),
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
            ),
            child: Container(
              // margin: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageBaseUrl + widget.item.images[0],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: mq.width * 0.6,
            height: mq.width * 0.48,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 60,
                  child: RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 25.0),
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 19.0,
                        color: titleColor,
                        fontWeight: FontWeight.normal,
                      ),
                      text: widget.item.articleTitle,
                    ),
                  ),
                ),
                Container(
                  height: 90,
                  child: RichText(
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.ellipsis,
                    strutStyle: StrutStyle(fontSize: 12.0),
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white70,
                      ),
                      text: widget.item.articleDescription,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                          addFavor(context, widget.item.id);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FavouriteScreen(
                          //       item: widget.item,
                          //     ),
                          //   ),
                          // );
                        },
                        child: favoriteIcon,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.share_outlined,
                          color: Colors.white70,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    return articleItem;
  }
}
