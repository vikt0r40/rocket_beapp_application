class SocialHelper {
  String baseLink = "";
  String mobileLink = "";

  bool isSocial(String link) {
    if (link.startsWith("https://www.instagram.com") || link.startsWith("https://instagram.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.instagram.com/";
      } else {
        baseLink = "https://instagram.com/";
      }
      mobileLink = "instagram://user?username=";
      return true;
    }
    if (link.startsWith("https://www.facebook.com") || link.startsWith("https://facebook.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.facebook.com/";
      } else {
        baseLink = "https://facebook.com/";
      }
      mobileLink = "fb://";
      return true;
    }
    if (link.startsWith("https://www.twitter.com") || link.startsWith("https://twitter.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.twitter.com/";
      } else {
        baseLink = "https://twitter.com/";
      }
      mobileLink = "twitter://search?query=";
      return true;
    }
    if (link.startsWith("https://www.tiktok.com") || link.startsWith("https://tiktok.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.tiktok.com/";
      } else {
        baseLink = "https://tiktok.com/";
      }
      mobileLink = "tiktok://";
      return true;
    }
    if (link.startsWith("https://www.youtube.com") || link.startsWith("https://youtube.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.youtube.com/";
      } else {
        baseLink = "https://youtube.com/";
      }
      mobileLink = "youtube://";
      return true;
    }
    if (link.startsWith("https://www.linkedin.com") || link.startsWith("https://linkedin.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.linkedin.com/";
      } else {
        baseLink = "https://linkedin.com/";
      }
      mobileLink = "linkedin://";
      return true;
    }
    if (link.startsWith("https://www.snapchat.com") || link.startsWith("https://snapchat.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.snapchat.com/";
      } else {
        baseLink = "https://snapchat.com/";
      }
      mobileLink = "snapchat://";
      return true;
    }
    if (link.startsWith("https://www.pinterest.com") || link.startsWith("https://pinterest.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.pinterest.com/";
      } else {
        baseLink = "https://pinterest.com/";
      }
      mobileLink = "pinterest://";
      return true;
    }
    if (link.startsWith("https://www.vimeo.com") || link.startsWith("https://vimeo.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.vimeo.com/";
      } else {
        baseLink = "https://vimeo.com/";
      }
      mobileLink = "vimeo://";
      return true;
    }
    if (link.startsWith("https://www.whatsapp.com") || link.startsWith("https://whatsapp.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.whatsapp.com/";
      } else {
        baseLink = "https://whatsapp.com/";
      }
      mobileLink = "whatsapp://";
      return true;
    }
    if (link.startsWith("https://www.viber.com") || link.startsWith("https://viber.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.viber.com/";
      } else {
        baseLink = "https://viber.com/";
      }
      mobileLink = "viber://";
      return true;
    }
    if (link.startsWith("https://www.telegram.com") || link.startsWith("https://telegram.com")) {
      if (link.contains("www.")) {
        baseLink = "https://www.telegram.com/";
      } else {
        baseLink = "https://telegram.com/";
      }
      mobileLink = "telegram://";
      return true;
    }

    return false;
  }

  String getSocialMobileLink(String link) {
    String mobileFriendlyLink = link.replaceAll(baseLink, mobileLink);
    return mobileFriendlyLink;
  }
}
