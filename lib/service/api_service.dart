import 'package:be_app_mobile/models/be_analytics.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/be_user.dart';
import 'package:be_app_mobile/models/message.dart';
import 'package:be_app_mobile/models/video.dart';
import 'package:be_app_mobile/offline_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:universal_platform/universal_platform.dart';

import '../models/app_options.dart';
import '../models/feedback.dart';
import '../models/general.dart';
import '../models/invite.dart';
import '../models/side_item.dart';
import '../models/woo_config.dart';
import '../screens/items/woo_commerce/woo_globals.dart';

enum AnalyticsType { visitors, userShares, feedbacks, userRates, device }

class APIService {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection("users");
  final CollectionReference generalSettingsCollection = FirebaseFirestore.instance.collection("settings");

  List<Video> listVideos = <Video>[];
  OfflineSettings offlineSettings = OfflineSettings();

  Future load() async {
    listVideos = await getVideoList();
  }

  Future getVideoList() async {
    if (offlineSettings.enableOfflineMode) {
      return [];
    }
    var data = await FirebaseFirestore.instance.collection("videos").get();

    var videoList = <Video>[];
    QuerySnapshot<Object?> feedbacks;

    if (data.docs.isEmpty) {
      return videoList;
    } else {
      feedbacks = data;
    }

    for (var element in feedbacks.docs) {
      Video video = Video.fromJson(element.data() as Map<dynamic, dynamic>);
      video.uid = element.reference.id;
      await video.loadController();
      videoList.add(video);
    }

    return videoList.reversed.toList();
  }

  Future sendFeedback(BeFeedback feedback) async {
    await FirebaseFirestore.instance.collection("feedbacks").add(feedback.toJson());
  }

  Future registerUser(User user, String registerType, String name) async {
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "user_id": user.uid,
      "display_name": user.displayName ?? name,
      "email": user.email,
      "type": registerType,
    });
  }

  Future removeFeedback(BeFeedback feedback) async {
    await FirebaseFirestore.instance.collection("feedbacks").doc(feedback.uid).delete();
  }

  Future<General> getGeneralSettings() async {
    if (offlineSettings.enableOfflineMode) {
      return offlineSettings.getGeneralSettings();
    }
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("settings").doc("general").get();
    if (snapshot.data() == null) {
      General general = General();
      //Create home item
      SideItem homeItem = SideItem(title: "Home");
      homeItem.type = ItemType.home;
      homeItem.iconCode = FontAwesomeIcons.house.codePoint;
      homeItem.fontFamily = FontAwesomeIcons.house.fontFamily ?? "";

      //Create chat item
      SideItem chatItem = SideItem(title: "Chat");
      chatItem.type = ItemType.chat;
      chatItem.iconCode = FontAwesomeIcons.comment.codePoint;
      chatItem.fontFamily = FontAwesomeIcons.comment.fontFamily ?? "";

      List<SideItem> exampleItems = [homeItem, chatItem];
      await updateSideItems(exampleItems);
      await updateNavItems(exampleItems);
      await updateFloatingItems(exampleItems);
      await updateGeneralSettings(general);
      return general;
    }
    return General.fromJson(snapshot.data() as Map<dynamic, dynamic>);
  }

  List<Message> getListMessages(DocumentSnapshot data) {
    List<Message> messages = [];
    if (data.exists && data["messages"] != null) {
      data['messages'].forEach((v) {
        messages.add(Message.fromJson(v));
      });
      return messages;
    }
    return messages;
  }

  Future<List<Message>> getMessages(String userId) async {
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("conversations").doc(userId).get();
    List<Message> messages = [];
    if (snapshot.data() != null) {
      Map<dynamic, dynamic> data = snapshot.data() as Map<dynamic, dynamic>;
      if (data["messages"] != null) {
        data['messages'].forEach((v) {
          messages.add(Message.fromJson(v));
        });
        return messages;
      }
    }
    return messages;
  }

  sendMessage(List<Message> messages, String userId, String username, String token) async {
    await FirebaseFirestore.instance
        .collection("conversations")
        .doc(userId)
        .set({"messages": messages.map((v) => v.toJson()).toList(), "user_name": username, "token": token});
  }

  Future updateInvites(List<Invite> items) async {
    bool keyExist = await checkIfKeyExist("items");
    if (keyExist) {
      await generalSettingsCollection.doc("options").update({"invites": items.map((v) => v.toJson()).toList()});
    } else {
      await generalSettingsCollection.doc("options").set({"invites": items.map((v) => v.toJson()).toList()});
    }
  }

  Future<AppOptions> getSideItems() async {
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("settings").doc("options").get();

    if (snapshot.data() == null) {
      AppOptions helper = AppOptions();
      return helper;
    }

    Map<dynamic, dynamic> itemsMaps = snapshot.data() as Map<dynamic, dynamic>;

    AppOptions helper = AppOptions.fromJson(itemsMaps);

    return helper;
  }

  logEvent(AnalyticsType type) async {
    if (offlineSettings.enableOfflineMode) {
      return;
    }
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("analytics").doc("analytics").get();

    if (snapshot.data() != null) {
      Map<dynamic, dynamic> analyticsData = snapshot.data() as Map<dynamic, dynamic>;
      BeAnalytics analytics = BeAnalytics.fromJson(analyticsData);
      if (type == AnalyticsType.visitors) {
        analytics.visitors++; //userShares, feedbacks, userRates,
      } else if (type == AnalyticsType.feedbacks) {
        analytics.feedbacks++;
      } else if (type == AnalyticsType.userShares) {
        analytics.userShares++;
      } else if (type == AnalyticsType.userRates) {
        analytics.rates++;
      } else if (type == AnalyticsType.device) {
        if (UniversalPlatform.isAndroid) {
          analytics.androidDevices++;
        } else {
          analytics.appleDevices++;
        }
      }
      await FirebaseFirestore.instance.collection("analytics").doc("analytics").update(analytics.toJson());
    } else {
      BeAnalytics analytics = BeAnalytics();
      if (type == AnalyticsType.visitors) {
        analytics.visitors++; //userShares, feedbacks, userRates,
      } else if (type == AnalyticsType.feedbacks) {
        analytics.feedbacks++;
      } else if (type == AnalyticsType.userShares) {
        analytics.userShares++;
      } else if (type == AnalyticsType.userRates) {
        analytics.rates++;
      } else if (type == AnalyticsType.device) {
        if (UniversalPlatform.isAndroid) {
          analytics.androidDevices++;
        } else {
          analytics.appleDevices++;
        }
      }
      await FirebaseFirestore.instance.collection("analytics").doc("analytics").set(analytics.toJson());
    }
  }

  Future<BeAppModel> getAppConfiguration() async {
    if (offlineSettings.enableOfflineMode) {
      BeAppModel model = BeAppModel(options: offlineSettings.getApplicationSettings(), general: offlineSettings.getGeneralSettings());
      return model;
    }
    AppOptions options = AppOptions();
    General general = General();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("settings").get();
    BeAppModel app = BeAppModel(options: options, general: general);

    app.wooConfig = await getWooConfig();
    key = app.wooConfig?.wooKey ?? "";
    website = app.wooConfig?.getWebsiteUrl() ?? "";
    secret = app.wooConfig?.wooSecret ?? "";
    stripeSecret = app.wooConfig?.stripeSecretKey ?? "";

    if (querySnapshot.docs.isNotEmpty) {
      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        if (documentSnapshot.id == "general") {
          app.general = General.fromJson(documentSnapshot.data() as Map<dynamic, dynamic>);
        }
        if (documentSnapshot.id == "options") {
          app.options = AppOptions.fromJson(documentSnapshot.data() as Map<dynamic, dynamic>);
        }
      }
      return app;
    }
    return app;
  }

  Future updateNavItems(List<SideItem> items) async {
    bool keyExist = await checkIfKeyExist("items");
    if (keyExist) {
      await FirebaseFirestore.instance.collection("settings").doc("options").update({"navItems": items.map((v) => v.toJson()).toList()});
    } else {
      await FirebaseFirestore.instance.collection("settings").doc("options").set({"navItems": items.map((v) => v.toJson()).toList()});
    }
  }

  Future updateFloatingItems(List<SideItem> items) async {
    bool keyExist = await checkIfKeyExist("items");
    if (keyExist) {
      await FirebaseFirestore.instance.collection("settings").doc("options").update({"floatingItems": items.map((v) => v.toJson()).toList()});
    } else {
      await FirebaseFirestore.instance.collection("settings").doc("options").set({"floatingItems": items.map((v) => v.toJson()).toList()});
    }
  }

  Future updateGeneralSettings(General general) async {
    await FirebaseFirestore.instance.collection("settings").doc("general").set(general.toJson());
  }

  Future updateSideItems(List<SideItem> items) async {
    bool keyExist = await checkIfKeyExist("items");
    if (keyExist) {
      await FirebaseFirestore.instance.collection("settings").doc("options").update({"items": items.map((v) => v.toJson()).toList()});
    } else {
      await FirebaseFirestore.instance.collection("settings").doc("options").set({"items": items.map((v) => v.toJson()).toList()});
    }
  }

  Future<WooConfig> getWooConfig() async {
    if (offlineSettings.enableOfflineMode) {
      return offlineSettings.getWooCommerceSettings();
    }
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("woo_commerce").doc("settings").get();
    if (snapshot.data() == null) {
      return WooConfig();
    } else {
      return WooConfig.fromJson(snapshot.data() as Map<dynamic, dynamic>);
    }
  }

  Future checkIfKeyExist(String key) async {
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance.collection("settings").doc("options").get();
    if (snapshot.data() != null) {
      return true;
    } else {
      return false;
    }
  }

  updateUserSettings() async {
    BeUser user = await getUserSettings();
    await usersCollection.doc(FirebaseAuth.instance.currentUser?.uid ?? "").set(user.toJson());
  }

  updateUserSettingsWithUser(BeUser user) async {
    await usersCollection.doc(FirebaseAuth.instance.currentUser?.uid ?? "").set(user.toJson());
  }

  Future<BeUser> getUserSettings() async {
    DocumentSnapshot<Object?> snapshot = await usersCollection.doc(FirebaseAuth.instance.currentUser?.uid ?? "").get();

    if (snapshot.data() == null) {
      return BeUser(uid: "", displayName: "", email: "");
    }

    Map<dynamic, dynamic> itemsMaps = snapshot.data() as Map<dynamic, dynamic>;

    return BeUser.fromJson(itemsMaps);
  }
}
