import 'package:be_app_mobile/models/side_item.dart';
import 'package:be_app_mobile/screens/items/wordpress/wp_post_details_screen.dart';
import 'package:be_app_mobile/service/wordpress_service.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

import '../../../models/general.dart';
import '../../../models/wp_post.dart';
import '../woo_commerce/woo_globals.dart';

class WPPostsScreen extends StatefulWidget {
  const WPPostsScreen({Key? key, required this.general, required this.item}) : super(key: key);
  final General general;
  final SideItem item;
  @override
  State<WPPostsScreen> createState() => _WPPostsScreenState();
}

class _WPPostsScreenState extends State<WPPostsScreen> {
  WPService wpService = WPService(apiURL: "");
  List<WPPost> posts = [];

  @override
  void initState() {
    // TODO: implement initState
    wpService = WPService(apiURL: widget.item.link);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wpService.getWPPosts(),
      builder: (BuildContext context, AsyncSnapshot<List<WPPost>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return Loading(general: widget.general);
          } else {
            posts = snapshot.data!;
            if (isRTL) {
              return Directionality(textDirection: TextDirection.rtl, child: postsWidget());
            }
            return postsWidget();
          }
        } else {
          return Loading(general: widget.general);
        }
      },
    );
  }

  Widget postsWidget() {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            WPPost post = posts[index];
            return postWidget(post);
          }),
    ));
  }

  Widget postWidget(WPPost post) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WPPostDetailScreen(
                      post: post,
                      general: widget.general,
                    )))
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Stack(
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.width * 0.90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: Colors.white,
                    boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0.0, 4.0), blurRadius: 10.0, spreadRadius: 0.10)]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.0),
                  child: CachedNetworkImage(
                    imageUrl: post.postImage,
                    fit: BoxFit.cover,
                  ),
                )),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Text(
                      post.title,
                      style: const TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(radius: 10.0, backgroundImage: CachedNetworkImageProvider(post.authorImage)),
                      const SizedBox(width: 8.0),
                      Text(post.authorName, style: const TextStyle(color: Colors.white, fontSize: 14.0)),
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.timer,
                    size: 10.0,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5.0),
                  Text(dateCreated(post),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ))
                ],
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: GestureDetector(
                  onTap: () {
                    Share.share("${post.title} ${post.postImage}", subject: post.title);
                  },
                  child: const FaIcon(
                    FontAwesomeIcons.share,
                    color: Colors.white,
                    size: 26,
                  )),
            )
          ],
        ),
      ),
    );
  }

  String dateCreated(WPPost post) {
    var now = DateTime.now().toLocal();
    var date = post.dateCreated.toLocal();
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
