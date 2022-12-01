import 'package:be_app_mobile/models/wp_post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/general.dart';
import '../woo_commerce/woo_globals.dart';

class WPPostDetailScreen extends StatefulWidget {
  const WPPostDetailScreen({Key? key, required this.post, required this.general}) : super(key: key);
  final WPPost post;
  final General general;
  @override
  State<WPPostDetailScreen> createState() => _WPPostDetailScreenState();
}

class _WPPostDetailScreenState extends State<WPPostDetailScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isRTL ? Directionality(textDirection: TextDirection.rtl, child: mainArea()) : mainArea(),
    );
  }

  Widget mainArea() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: widget.post.postImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60.0), topRight: Radius.circular(60.0)),
                ),
                child: const SizedBox(width: 1),
              ),
            ),
            Positioned(
              top: 10,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 15, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    GestureDetector(
                        onTap: () {
                          Share.share("${widget.post.title} ${widget.post.postImage}", subject: widget.post.title);
                        },
                        child: const FaIcon(
                          FontAwesomeIcons.share,
                          color: Colors.black,
                          size: 16,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.post.title,
                  style: const TextStyle(fontSize: 28.0, color: Colors.black, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.timer,
                          color: Colors.grey,
                          size: 16.0,
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          dateCreated(),
                          style: const TextStyle(color: Colors.grey, fontSize: 16.0),
                        )
                      ],
                    ),
                    const SizedBox(width: 20.0),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(widget.post.authorImage),
                      radius: 28.0,
                    ),
                    const SizedBox(width: 10.0),
                    Text(
                      widget.post.authorName,
                      style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600, letterSpacing: 0.8),
                    )
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  widget.post.content,
                  style: const TextStyle(fontSize: 18.0, color: Colors.grey, letterSpacing: 1),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void lunchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw "Could not launch $url";
    }
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
