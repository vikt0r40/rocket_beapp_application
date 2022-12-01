import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class BeHtmlText extends StatefulWidget {
  const BeHtmlText({Key? key, required this.htmlText}) : super(key: key);
  final String htmlText;

  @override
  State<BeHtmlText> createState() => _BeHtmlTextState();
}

class _BeHtmlTextState extends State<BeHtmlText> {
  final GlobalKey webViewKey = GlobalKey();
  double height = 0;
  InAppWebViewController? _webViewController;

  late String html;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadAsset(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData && snapshot.hasError == false) {
          String htmlData = snapshot.data ?? "";
          String formatted = htmlData.replaceAll("replace_this_text", widget.htmlText);
          html = Uri.dataFromString(formatted, mimeType: "text/html", encoding: Encoding.getByName("utf-8")).toString();
          debugPrint(html);
          return SizedBox(
            height: height == 0 ? 100 : height,
            child: InAppWebView(
              key: webViewKey,
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    transparentBackground: true,
                    horizontalScrollBarEnabled: false,
                    minimumFontSize: 16,
                    verticalScrollBarEnabled: false,
                    supportZoom: false),
                android: AndroidInAppWebViewOptions(useHybridComposition: true, useWideViewPort: false),
              ),
              initialData: InAppWebViewInitialData(data: formatted),
              //initialUrlRequest: URLRequest(url: Uri.parse(html)),
              onWebViewCreated: (controller) async {
                int? contentHeight = await controller.getContentHeight();
                double? zoomScale = await controller.getZoomScale();
                double htmlHeight = contentHeight!.toDouble() * zoomScale!;
                double htmlHeightFixed = double.parse(htmlHeight.toStringAsFixed(2));
                if (htmlHeightFixed == 0.0) {
                  return;
                }
                setState(() {
                  height = htmlHeightFixed + 0.1;
                });
              },
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/html.txt');
  }
}
