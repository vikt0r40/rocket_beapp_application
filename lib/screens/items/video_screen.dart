import 'package:be_app_mobile/service/api_service.dart';
import 'package:be_app_mobile/widgets/app_video_player.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../../models/general.dart';
import '../../models/video.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key, required this.general}) : super(key: key);
  final General general;
  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  APIService service = APIService();
  bool isLoading = true;

  @override
  void dispose() {
    super.dispose();
    for (Video v in service.listVideos) {
      v.controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.general.getApplicationColor(),
      body: FutureBuilder(
        future: service.load(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (service.listVideos.isNotEmpty) {
            return PageView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Video video = service.listVideos[index];
                  for (Video v in service.listVideos) {
                    v.controller?.pause();
                  }
                  video.controller?.play();
                  return AppVideoPlayer(general: widget.general, video: video);
                },
                itemCount: service.listVideos.length);
          }
          return Loading(general: widget.general);
        },
      ),
    );
  }
}
