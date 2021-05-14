import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../model/article_model.dart';

class Service {
  String domain = 'http://www.semvac.info/adminpanel';
  // String domain = 'http://10.10.10.108:8080/manager';

  Future<List<Article>> getArticleList() async {
    try {
      List<Article> result = [];
      var response = await http.get(
        "$domain/index.php/mobile?type=get_articles",
      );
      final body = convert.jsonDecode(response.body);
      print(body);
      final data = body["data"];
      if (response.statusCode == 200) {
        for (var i = 0; i < data["data"].length; i++) {
          result.add(Article.fromJSON(data["data"][i]));
          print(result[i].articleTitle);
        }
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addFvorites(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_favor&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> removeFvorites(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=remove_favor&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<List<Article>> getFavoriteArticleList(String ids) async {
    try {
      List<Article> result = [];
      var response = await http.post(
        "$domain/index.php/mobile?type=get_favors&ids=$ids",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      final body = convert.jsonDecode(response.body);
      final data = body["data"];
      print(body["data"]);
      if (response.statusCode == 200) {
        for (var i = 0; i < data["data"].length; i++) {
          result.add(Article.fromJSON(data["data"][i]));
          print(result[i].articleTitle);
        }
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<Article> getArticleById(String id) async {
    try {
      Article result;
      var response = await http.post(
        "$domain/index.php/mobile?type=get_article&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      final body = convert.jsonDecode(response.body);
      final data = body["data"];
      print(body["data"]);
      if (response.statusCode == 200) {
        result = Article.fromJSON(data);
      }
      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addShares(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_share&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<bool> addOpens(String id) async {
    try {
      var response = await http.post(
        "$domain/index.php/mobile?type=add_open&id=$id",
        headers: {
          "accept": "application/json",
          "cache-control": "no-cache",
          "content-type": "application/json"
        },
      );
      // final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      rethrow;
    }
  }
}
