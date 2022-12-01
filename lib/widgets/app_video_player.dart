import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/general.dart';
import '../models/video.dart';
import 'loading.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({Key? key, required this.general, required this.video}) : super(key: key);
  final General general;
  final Video video;
  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  @override
  void initState() {
    super.initState();
    if (widget.video.controller != null) {
    } else {
      // widget.video.controller = VideoPlayerController.network(widget.video.url)
      //   ..initialize().then((_) {
      //     //_controller?.play();
      //     setState(() {});
      //   });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: widget.video.controller != null ? videoCard(widget.video) : Loading(general: widget.general));
  }

  @override
  void dispose() {
    super.dispose();
    //widget.video.controller?.dispose();
  }

  Widget videoCard(Video video) {
    return Stack(
      children: [
        widget.video.controller == null
            ? Loading(general: widget.general)
            : GestureDetector(
                onTap: () {
                  if (widget.video.controller!.value.isPlaying) {
                    widget.video.controller?.pause();
                  } else {
                    widget.video.controller?.play();
                  }
                },
                child: SizedBox.expand(
                    child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: widget.video.controller?.value.size.width ?? 0,
                    height: widget.video.controller?.value.size.height ?? 0,
                    child: VideoPlayer(widget.video.controller!),
                  ),
                )),
              ),
      ],
    );
  }
}
