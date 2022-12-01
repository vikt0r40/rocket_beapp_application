class YVideo {
  String videoID = "";
  String videoTitle = "";
  bool isLive = false;
  bool autoPlay = false;
  bool hideControls = false;
  bool forceHD = true;
  YVideo({required this.videoID});

  YVideo.fromJson(Map<dynamic, dynamic> json) {
    videoID = json["videoID"] ?? "";
    videoTitle = json["videoTitle"] ?? "";
    isLive = json["isLive"] ?? false;
    autoPlay = json["autoPlay"] ?? false;
    hideControls = json["hideControls"] ?? false;
    forceHD = json["forceHD"] ?? true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["videoID"] = videoID;
    data["videoTitle"] = videoTitle;
    data["isLive"] = isLive;
    data["autoPlay"] = autoPlay;
    data["hideControls"] = hideControls;
    data["forceHD"] = forceHD;
    return data;
  }
}
