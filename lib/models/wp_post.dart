import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class WPPost {
  int postID = 0;
  DateTime dateCreated = DateTime.now();
  DateTime dateModified = DateTime.now();
  String slug = "";
  String status = "";
  String type = "";
  String link = "";
  String title = "";
  String content = "";
  String contentExcerpt = "excerpt";
  String authorName = "";
  String authorImage = "";
  String postImage = "";
  int authorID = 1;
  String commentStatus = "";
  String format = "";

  WPPost();

  WPPost.fromJson(Map<String, dynamic> json) {
    postID = json['id'] ?? 0;
    if (json['date_gmt'] != null) {
      dateCreated = DateTime.parse(json['date_gmt']);
    }
    if (json['modified'] != null) {
      dateModified = DateTime.parse(json['modified']);
    }
    slug = json['slug'] ?? "";
    status = json['status'] ?? "";
    type = json['type'] ?? "";
    link = json['link'] ?? "";
    if (json['title'] != null && json['title']['rendered'] != null) {
      title = json['title']['rendered'] ?? "";
    }
    if (json['content'] != null && json['content']['rendered'] != null) {
      content = json['content']['rendered'] ?? "";
    }
    if (json['excerpt'] != null && json['excerpt']['rendered'] != null) {
      contentExcerpt = json['excerpt']['rendered'] ?? "";
    }
    authorID = json['author'] ?? 1;
    commentStatus = json['comment_status'] ?? "";
    format = json['format'] ?? "";
    if (json['_embedded'] != null) {
      //Get author details
      if (json['_embedded']["author"] != null) {
        List<dynamic> authors = json['_embedded']["author"];
        if (authors.isNotEmpty) {
          Map<String, dynamic> author = authors[0];
          authorName = author['name'] ?? "";
          if (author['avatar_urls'] != null) {
            authorImage = author['avatar_urls']['96'] ?? "";
          }
        }
      }

      //Get Post Image
      if (json['_embedded']['wp:featuredmedia'] != null) {
        List<dynamic> images = json['_embedded']["wp:featuredmedia"];
        if (images.isNotEmpty) {
          Map<String, dynamic> image = images[0];
          if (image['media_details'] != null && image['media_details']['sizes'] != null && image['media_details']['sizes']['medium'] != null) {
            postImage = image['media_details']['sizes']['full']['source_url'] ?? "";
          }
        }
      }
    }
  }

  debugPrintInformation() {
    debugPrint("-----Start-----");
    debugPrint(title);
    debugPrint(postImage);
    debugPrint(contentExcerpt);
    debugPrint(authorName);
    debugPrint(authorImage);
    debugPrint(link);
    debugPrint(type);
    debugPrint(DateFormat('dd-MM-yyyy – HH:mm').format(dateCreated));
    debugPrint(DateFormat('dd-MM-yyyy – HH:mm').format(dateModified));
    debugPrint("-----End-----");
    debugPrint(" ");
  }
}
