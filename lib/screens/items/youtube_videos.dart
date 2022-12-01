import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/side_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../models/general.dart';

class YouTubeVideos extends StatefulWidget {
  const YouTubeVideos({Key? key, required this.item, required this.general}) : super(key: key);
  final SideItem item;
  final General general;
  @override
  State<YouTubeVideos> createState() => _YouTubeVideosState();
}

class _YouTubeVideosState extends State<YouTubeVideos> {
  double size = 0.0;
  List<YoutubePlayerController> _controllers = [];
  @override
  void initState() {
    // TODO: implement initState
    _controllers = widget.item.youtubeVideos
        .map<YoutubePlayerController>(
          (video) => YoutubePlayerController(
            initialVideoId: video.videoID,
            params: YoutubePlayerParams(
                startAt: const Duration(seconds: 0),
                showControls: !video.hideControls,
                showFullscreenButton: true,
                autoPlay: video.autoPlay,
                loop: video.isLive),
            //flags: YoutubePlayerFlags(autoPlay: video.autoPlay, isLive: video.isLive, hideControls: video.hideControls, forceHD: video.forceHD),
          ),
        )
        .toList();
    for (var controller in _controllers) {
      controller.onEnterFullscreen = () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
      controller.onExitFullscreen = () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      };
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.general.getApplicationColor(),
      body: Stack(
        children: [
          ListView.separated(
            itemBuilder: (context, index) {
              return Column(
                children: [
                  YoutubePlayerControllerProvider(
                    // Provides controller to all the widget below it.
                    controller: _controllers[index],
                    child: const YoutubePlayerIFrame(
                      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
                      aspectRatio: 16 / 9,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        height: 80,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          widget.item.youtubeVideos[index].videoTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: getFontStyle(16, Colors.white, FontWeight.normal, widget.general),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
            itemCount: _controllers.length,
            separatorBuilder: (context, _) {
              return SizedBox(height: size);
            },
          ),
        ],
      ),
    );
  }
}
