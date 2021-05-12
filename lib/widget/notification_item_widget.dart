import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';
import '../model/article_model.dart';
import '../widget/loading.dart';
import '../service/api.dart';
import '../config/color.dart';

class NotificationWidget extends StatefulWidget {
  final Map item;
  NotificationWidget({Key key, @required this.item}) : super(key: key);
  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  Service _service = new Service();
  Future<Article> _getArticle;

  @override
  void initState() {
    _getArticle = getArticleById(widget.item['article_id']);
    // _getArticle = getArticleById('2');
    super.initState();
  }

  Future<Article> getArticleById(id) async {
    var result = await _service.getArticleById(id);
    return result;
  }

  Widget body(data) {
    var mq = MediaQuery.of(context).size;
    return Card(
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
                  imageBaseUrl + data.images[0],
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
                      text: data.articleTitle,
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
                      text: widget.item['text'],
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => FavouriteScreen(
                          //       item: widget.item,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Icon(
                          Icons.delete_rounded,
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
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    // return body();
    return LayoutBuilder(
      builder: (context, constraint) {
        return FractionallySizedBox(
          widthFactor: 1.0,
          child: FutureBuilder<Article>(
            future: _getArticle,
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
    );
  }
}
