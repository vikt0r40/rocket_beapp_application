import 'package:be_app_mobile/models/wp_post.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class WPService {
  static String postsURL = "posts?_embed";
  static String restApiPath = "wp-json/wp/v2/";
  String apiURL = "";

  WPService({required this.apiURL});

  Future<List<WPPost>> getWPPosts() async {
    List<WPPost> posts = [];
    try {
      String url = getApiURL() + restApiPath + postsURL;
      var response = await Dio().get(url,
          options: Options(headers: {
            "Content-type": "application/json",
          }));

      if (response.statusCode == 200) {
        for (Map<String, dynamic> post in response.data) {
          posts.add(WPPost.fromJson(post));
        }
        return posts;
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }

    return posts;
  }

  String getApiURL() {
    if (!apiURL.endsWith("/")) {
      apiURL = "$apiURL/";
    }
    if (!apiURL.contains("http")) {
      return "https://$apiURL";
    } else {
      return apiURL;
    }
  }
}
