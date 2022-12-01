class Social {
  String facebook = "";
  String instagram = "";
  String twitter = "";
  String pinterest = "";
  String linkedin = "";
  String tiktok = "";
  String youtube = "";
  String vimeo = "";

  Social(
      {this.facebook = "",
      this.instagram = "",
      this.twitter = "",
      this.pinterest = "",
      this.linkedin = "",
      this.tiktok = "",
      this.youtube = "",
      this.vimeo = ""});

  Social.fromJson(Map<dynamic, dynamic> json) {
    facebook = json['facebook'] ?? "";
    instagram = json['instagram'] ?? "";
    twitter = json['twitter'] ?? "";
    pinterest = json['pinterest'] ?? "";
    linkedin = json['linkedin'] ?? "";
    tiktok = json['tiktok'] ?? "";
    youtube = json['youtube'] ?? "";
    vimeo = json['vimeo'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['facebook'] = facebook;
    data['instagram'] = instagram;
    data['twitter'] = twitter;
    data['pinterest'] = pinterest;
    data['linkedin'] = linkedin;
    data['tiktok'] = tiktok;
    data['youtube'] = youtube;
    data['vimeo'] = vimeo;
    return data;
  }

  bool hasSocial() {
    if (facebook.isEmpty &&
        instagram.isEmpty &&
        twitter.isEmpty &&
        pinterest.isEmpty &&
        linkedin.isEmpty &&
        tiktok.isEmpty &&
        youtube.isEmpty &&
        vimeo.isEmpty) {
      return false;
    }
    return true;
  }
}
