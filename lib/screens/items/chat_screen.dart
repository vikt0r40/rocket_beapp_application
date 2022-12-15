import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/message.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/service/api_service.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:be_app_mobile/widgets/webview_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/general.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key, required this.general, required this.options}) : super(key: key);
  final General general;
  final AppOptions options;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? userName;
  String? userId;
  String? token;
  final nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final scrollController = ScrollController();
  List<Message> messages = [];
  String messageText = "";
  bool _needsScroll = false;

  @override
  void initState() {
    // TODO: implement initState
    loadPushToken();
    super.initState();
  }

  loadPushToken() async {
    token = await FirebaseMessaging.instance.getToken();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
      _needsScroll = false;
    }
    if (widget.general.enableAuthorization) {
      userId = FirebaseAuth.instance.currentUser?.uid;
      userName = FirebaseAuth.instance.currentUser?.displayName;
      return stream();
    } else {
      return startWithNoAuthorization();
    }
  }

  Widget startWithNoAuthorization() {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
          if (!snapshot.hasError && snapshot.hasData) {
            SharedPreferences preferences = snapshot.data!;
            if (preferences.getString("user_id") != null && preferences.getString("user_name") != null) {
              userId = preferences.getString("user_id");
              userName = preferences.getString("user_name");

              return stream();
            }
            return loginWidget();
          }
          return Loading(
            general: widget.general,
          );
        });
  }

  Widget stream() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("conversations").doc(userId).snapshots(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          var doc = snapshot.data as DocumentSnapshot;
          messages = APIService().getListMessages(doc);
          return chatArea();
        }
        return Loading(
          general: widget.general,
        );
      },
    );
  }

  Widget chatArea() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 70),
            physics: const ScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                child: Align(
                  alignment: (messages[index].userID != userId ? Alignment.topLeft : Alignment.topRight),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (messages[index].userID != userId ? Colors.grey.shade200 : Colors.blue[200]),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: isLinkMessage(messages[index].message) ? linkMessage(index) : regularMessage(index),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                          hintText: mainLocalization.localization.writeMessage,
                          hintStyle: getFontStyle(14, Colors.black, FontWeight.normal, widget.general),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      sendMessage();
                    },
                    backgroundColor: widget.general.getHeaderColor(),
                    elevation: 0,
                    child: Icon(
                      Icons.send,
                      color: widget.general.getHeaderItemsColor(),
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        primary: false,
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: widget.general.getTopNavigationColor(),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BeImage(
                    link: widget.general.logoUrl,
                    width: 250,
                    height: 150,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    mainLocalization.localization.waitWeNeedYourName,
                    style: getFontStyle(20, widget.general.getTopNavigationItemColor(), FontWeight.bold, widget.general),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2 + 50,
                    child: TextField(
                      style: getFontStyle(14, widget.general.getTopNavigationItemColor(), FontWeight.normal, widget.general),
                      obscureText: false,
                      cursorColor: widget.general.getTopNavigationItemColor(),
                      controller: nameController,
                      decoration: InputDecoration(
                          iconColor: widget.general.getTopNavigationItemColor(),
                          hoverColor: widget.general.getTopNavigationItemColor(),
                          focusColor: widget.general.getTopNavigationItemColor(),
                          prefixIconColor: widget.general.getTopNavigationItemColor(),
                          suffixIconColor: widget.general.getTopNavigationItemColor(),
                          fillColor: widget.general.getTopNavigationItemColor(),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.general.getTopNavigationItemColor(), width: 1.0)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: widget.general.getTopNavigationItemColor(), width: 1.0),
                          ),
                          labelText: mainLocalization.localization.yourNameHere,
                          labelStyle: getFontStyle(14, widget.general.getTopNavigationItemColor(), FontWeight.normal, widget.general)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                      width: 150,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          loginAction();
                        },
                        style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                        child: Text(
                          mainLocalization.localization.joinButton,
                          style: getFontStyle(16, Colors.white, FontWeight.normal, widget.general),
                        ),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginAction() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          mainLocalization.localization.userNameIsRequired,
          style: getFontStyle(16, Colors.redAccent, FontWeight.normal, widget.general),
        ),
      ));
      return;
    }
    userId = const Uuid().v4();
    userName = nameController.text;
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setString("user_name", userName ?? "");
    myPrefs.setString("user_id", userId ?? "");
    setState(() {});
  }

  void sendMessage() async {
    if (messageController.text.isEmpty) {
      return;
    } else {
      Message message = Message(userID: userId ?? "", userName: userName ?? "", message: messageController.text);
      messages.add(message);
      messageController.text = "";
      await APIService().sendMessage(messages, userId ?? "", userName ?? "", token ?? "");
    }
  }

  void scrollToBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
  }

  Widget regularMessage(int index) {
    return Text(
      messages[index].message,
      style: getFontStyle(15, Colors.black, FontWeight.normal, widget.general),
    );
  }

  Widget linkMessage(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: false,
            barrierColor: Colors.black,
            pageBuilder: (BuildContext context, _, __) {
              return WebScreen(
                urlString: messages[index].message,
                option: widget.options,
              );
            },
          ),
        );
      },
      child: Text(
        messages[index].message,
        style: getFontStyle(15, Colors.blue, FontWeight.normal, widget.general),
      ),
    );
  }

  bool isLinkMessage(String msg) {
    String pattern = r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)';
    RegExp regExp = RegExp(pattern);
    if (msg.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(msg)) {
      return false;
    } else {
      return true;
    }
  }
}
