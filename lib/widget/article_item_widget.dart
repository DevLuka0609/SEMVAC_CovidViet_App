import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:share/share.dart';

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
  String text = '';
  String subject = 'Chia sẻ bài này từ app của SEMVAC: ...';
  List<String> imagePaths = [];

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
            message: "SEMVAC cám ơn bạn thích thông tin này!",
            margin: EdgeInsets.all(8),
            duration: Duration(seconds: 1),
            mainButton: TextButton(
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
          var result = await _service.removeFvorites(id);
          print(result);
          break;
        }
      }
      storage.setItem("favorIds", favorIds);
      print(storage.getItem("favorIds"));
    }
  }

  void addShares(String id) async {
    var result = await _service.addShares(id);
    if (result == true) {
      print("Aritlce Shares Counts ++");
    } else {
      print("Aritlce Shares Counts Error!");
    }
  }

  _addTextImagePaths() {
    setState(() {
      for (var i = 0; i < widget.item.images.length; i++) {
        var path = imageBaseUrl + widget.item.images[i];
        // imagePaths.add(path);
        text = widget.item.articleTitle +
            "\n" +
            "\n" +
            widget.item.articleDescription +
            "\n" +
            path;
        print(text);
      }
    });
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject() as RenderBox;
    await Share.share(text,
        subject: subject,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
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
            height: mq.height * 0.26,
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
                        },
                        child: favoriteIcon,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          _addTextImagePaths();
                          _onShare(context);
                          addShares(widget.item.id);
                        },
                        child: Icon(
                          Icons.share_outlined,
                          color: Colors.white70,
                          size: 25,
                        ),
                      ),
                      SizedBox(
                        width: 25,
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
