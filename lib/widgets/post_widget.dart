import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/wp_post.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';

import '../models/general.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post, required this.onClick, required this.general}) : super(key: key);
  final WPPost post;
  final Function onClick;
  final General general;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 6),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(6.0, 2.0, 10.0, 2.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: BeImage(
                            link: widget.post.authorImage,
                            width: 48,
                            height: 48,
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.post.authorName,
                          style: getFontStyle(15, Colors.black, FontWeight.bold, widget.general),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            dateCreated(),
                            style: getFontStyle(14, Colors.black87, FontWeight.w300, widget.general),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onClick(widget.post);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 4, 10),
                  child: Text(
                    widget.post.title.length > 200 ? widget.post.title.substring(0, 132) : widget.post.title,
                    style: getFontStyle(16, Colors.black, FontWeight.w300, widget.general),
                    maxLines: 3,
                  ),
                ),
              ),
              widget.post.postImage.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        widget.onClick(widget.post);
                      },
                      child: BeImage(
                        link: widget.post.postImage,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width / 2,
                        fit: BoxFit.cover,
                      ))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String dateCreated() {
    var now = DateTime.now().toLocal();
    var date = widget.post.dateCreated.toLocal();
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      if (diff.inHours > 0) {
        time = '${diff.inHours}h';
      } else if (diff.inMinutes > 0) {
        time = '${diff.inMinutes}m';
      } else if (diff.inSeconds > 0) {
        time = 'now';
      } else if (diff.inMilliseconds > 0) {
        time = 'now';
      } else if (diff.inMicroseconds > 0) {
        time = 'now';
      } else {
        time = 'now';
      }
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = '${diff.inDays}d';
    } else if (diff.inDays > 6) {
      time = '${(diff.inDays / 7).floor()}w';
    } else if (diff.inDays > 29) {
      time = '${(diff.inDays / 30).floor()}m';
    } else if (diff.inDays > 365) {
      time = '${date.month} ${date.day}, ${date.year}';
    }
    return time;
  }
}
