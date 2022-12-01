import 'package:be_app_mobile/models/app_options.dart';
import 'package:flutter/material.dart';

import '../models/general.dart';
import '../screens/home_screen.dart';

class WebScreen extends StatefulWidget {
  const WebScreen({Key? key, required this.urlString, required this.option}) : super(key: key);
  final String urlString;
  final AppOptions option;

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          BeWebView(
            url: formattedUrl(),
            general: General(),
            callback: (webView) {},
            onPageFinish: () {},
            options: widget.option,
          ),
          backButton(),
        ],
      ),
    );
  }

  Widget backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: MaterialButton(
          padding: const EdgeInsets.all(10),
          elevation: 0,
          color: Colors.white70,
          highlightElevation: 0,
          minWidth: double.minPositive,
          height: double.minPositive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }

  String formattedUrl() {
    String formatted = "";
    if (!widget.urlString.contains("http")) {
      formatted = "https://${widget.urlString}";
      return formatted;
    }
    return widget.urlString;
  }
}
