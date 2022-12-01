import 'package:video_player/video_player.dart';

class Video {
  VideoPlayerController? controller;
  String url = "";
  String uid = "";
  Video({required this.url});

  Video.fromJson(Map<dynamic, dynamic> json) {
    url = json["url"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["url"] = url;
    return data;
  }

  Future<bool> loadController() async {
    controller = VideoPlayerController.network(url);
    await controller?.initialize();
    controller?.setLooping(true);
    return true;
  }
}
