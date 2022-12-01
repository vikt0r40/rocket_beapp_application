import 'package:be_app_mobile/models/be_app.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/woo_config.dart';
import '../screens/home_screen.dart';

class DemoWidget extends StatefulWidget {
  const DemoWidget({Key? key, required this.model}) : super(key: key);
  final BeAppModel model;
  @override
  State<DemoWidget> createState() => _DemoWidgetState();
}

class _DemoWidgetState extends State<DemoWidget> {
  TextEditingController urlController = TextEditingController();
  BoolValue enableTopBar = BoolValue(isEnabled: true);
  BoolValue enableBottomBar = BoolValue(isEnabled: true);
  BoolValue enableFloatingButton = BoolValue(isEnabled: true);
  BoolValue enableSafeArea = BoolValue(isEnabled: false);
  BoolValue enableRTL = BoolValue(isEnabled: false);
  BoolValue enablePinchZoom = BoolValue(isEnabled: false);
  BoolValue enableCookies = BoolValue(isEnabled: true);
  BoolValue enableMultiWindow = BoolValue(isEnabled: true);
  BoolValue enableBanner = BoolValue(isEnabled: false);
  BoolValue reloadOnBackground = BoolValue(isEnabled: false);
  BoolValue blockScreenshots = BoolValue(isEnabled: false);
  BoolValue enableHorizontalScroll = BoolValue(isEnabled: true);
  BoolValue enableWebViewLoadingIndicator = BoolValue(isEnabled: false);
  BoolValue enablePullDownToRefresh = BoolValue(isEnabled: true);
  @override
  void initState() {
    // TODO: implement initState
    urlController.text = "https://";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
        child: SingleChildScrollView(
          primary: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("images/app_icon.png"),
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "This screen is just for the demo. Enter your url or leave empty if you want to go with default url.",
                maxLines: 5,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2 + 50,
                height: 60,
                child: Stack(
                  children: [
                    TextField(
                      style: const TextStyle(color: Colors.black),
                      obscureText: false,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.url,
                      controller: urlController,
                      decoration: const InputDecoration(labelText: "Your url here (optional)", labelStyle: TextStyle(color: Colors.black)),
                    ),
                  ],
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
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    child: Text(
                      "Lets get in",
                      style: Theme.of(context).textTheme.button,
                    ),
                  )),
              const SizedBox(
                height: 30,
              ),
              settings(),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget settings() {
    return Column(children: [
      addSwitcher("Enable Top bar", enableTopBar),
      addSwitcher("Enable Bottom bar", enableBottomBar),
      addSwitcher("Enable Floating Button", enableFloatingButton),
      addSwitcher("Enable Safe Area", enableSafeArea),
      addSwitcher("Enable RTL", enableRTL),
      addSwitcher("Enable Pinch Zoom", enablePinchZoom),
      addSwitcher("Enable Cookies", enableCookies),
      addSwitcher("Enable Multi Window", enableMultiWindow),
      addSwitcher("Enable AdMob Banner", enableBanner),
      addSwitcher("Reload WebView on Background", reloadOnBackground),
      addSwitcher("Enable Horizontal Scroll", enableHorizontalScroll),
    ]);
  }

  void loginAction() {
    if (urlController.text.isNotEmpty && urlController.text.endsWith("://") == false) {
      if (urlController.text.startsWith("https://") || urlController.text.startsWith("http://")) {
        widget.model.general.mainURL = urlController.text;
      } else {
        String formattedUrl = "https://" + urlController.text;
        widget.model.general.mainURL = formattedUrl;
      }
    }

    widget.model.general.enableFloatingButton = enableFloatingButton.isEnabled;
    widget.model.general.enableBottomNavigation = enableBottomBar.isEnabled;
    widget.model.general.enableTopNavigation = enableTopBar.isEnabled;
    widget.model.general.enableSafeArea = enableSafeArea.isEnabled;
    widget.model.general.enableRTL = enableRTL.isEnabled;
    widget.model.general.enablePinchZoom = enablePinchZoom.isEnabled;
    widget.model.general.enableCookies = enableCookies.isEnabled;
    widget.model.general.enableMultiWindow = enableMultiWindow.isEnabled;
    widget.model.general.reloadWebViewOnBackground = reloadOnBackground.isEnabled;
    widget.model.general.enableScreenSecurity = blockScreenshots.isEnabled;
    widget.model.general.enableHorizontalScroll = enableHorizontalScroll.isEnabled;
    widget.model.general.pullDownToRefresh = enablePullDownToRefresh.isEnabled;
    widget.model.general.enableLoadingWebView = enableWebViewLoadingIndicator.isEnabled;

    if (enableBanner.isEnabled == true) {
      widget.model.general.enableBanner = enableBanner.isEnabled;
      widget.model.general.enabledAdmob = true;
      widget.model.general.enableInterstitials = false;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MobileScreen(
                  general: widget.model.general,
                  appOptions: widget.model.options,
                  wooConfig: widget.model.wooConfig ?? WooConfig(),
                )));
  }

  Widget addSwitcher(String title, BoolValue option) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Switch(
          value: option.isEnabled,
          onChanged: (value) {
            setState(() {
              option.isEnabled = value;
            });
          },
          activeTrackColor: Colors.black12,
          activeColor: Colors.black,
        )
      ],
    );
  }
}

class BoolValue {
  bool isEnabled = false;

  BoolValue({required this.isEnabled});
}
