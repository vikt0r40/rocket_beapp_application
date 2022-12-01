import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

import '../../models/general.dart';

class FullScreenPage extends StatefulWidget {
  const FullScreenPage({
    Key? key,
    required this.imageChild,
    required this.dark,
    required this.imageUrl,
    required this.general,
  }) : super(key: key);

  final Widget imageChild;
  final bool dark;
  final String imageUrl;
  final General general;
  @override
  State<FullScreenPage> createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        // Restore your settings here...
        ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: widget.imageChild,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: MaterialButton(
                  padding: const EdgeInsets.all(15),
                  elevation: 0,
                  color: widget.dark ? Colors.black12 : Colors.white70,
                  highlightElevation: 0,
                  minWidth: double.minPositive,
                  height: double.minPositive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: widget.dark ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(right: 10, top: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: MaterialButton(
                  padding: const EdgeInsets.all(15),
                  elevation: 0,
                  color: widget.dark ? Colors.black12 : Colors.white70,
                  highlightElevation: 0,
                  minWidth: double.minPositive,
                  height: double.minPositive,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () {
                    Share.share(widget.imageUrl);
                  },
                  child: Icon(
                    Icons.share,
                    color: widget.dark ? Colors.white : Colors.black,
                    size: 25,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: widget.general.allowDownloadingImagesInGallery,
            child: SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: MaterialButton(
                    padding: const EdgeInsets.all(15),
                    elevation: 0,
                    color: widget.dark ? Colors.black12 : Colors.white70,
                    highlightElevation: 0,
                    minWidth: double.minPositive,
                    height: double.minPositive,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    onPressed: () async {
                      await downloadImage();
                    },
                    child: Icon(
                      Icons.download,
                      color: widget.dark ? Colors.white : Colors.black,
                      size: 25,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  downloadImage() async {
    FlutterDownloader.registerCallback(callback);
    await FlutterDownloader.enqueue(
      url: widget.imageUrl,
      fileName: "image",
      savedDir: (await getExternalStorageDirectory())!.path,
      saveInPublicStorage: true,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
  }

  static void callback(String id, DownloadTaskStatus status, int progress) {
    debugPrint(id);
    debugPrint(status.value.toString());
    debugPrint(progress.toString());
  }
}
