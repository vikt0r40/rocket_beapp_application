import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/be_contact.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key, required this.options, required this.general}) : super(key: key);
  final AppOptions options;
  final General general;
  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool hasURL = false;
  bool hasVCard = false;
  bool hasText = false;
  String urlFound = "";
  String textMessage = "";
  BeContact contact = BeContact();

  @override
  Widget build(BuildContext context) {
    if (hasURL) {
      return webView();
    } else if (hasVCard) {
      return contactInfo();
    } else if (hasText) {
      return textInfo();
    } else {
      return mobileScanner();
    }
  }

  Widget mobileScanner() {
    return Stack(
      children: [
        MobileScanner(
            allowDuplicates: true,
            controller: cameraController,
            onDetect: (barcode, args) {
              final String? code = barcode.rawValue;
              String text = code ?? "";
              if (text.startsWith("https") || text.startsWith("http") || text.startsWith("www")) {
                setState(() {
                  hasURL = true;
                  urlFound = code ?? "";
                });
              } else if (code!.contains("VCARD")) {
                setState(() {
                  hasVCard = true;
                  var mainContact = Contact.fromVCard(code);
                  contact = BeContact().fromContact(mainContact);
                });
              } else {
                setState(() {
                  hasText = true;
                  textMessage = code;
                });
              }
            }),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: ValueListenableBuilder(
                      valueListenable: cameraController.torchState,
                      builder: (context, state, child) {
                        switch (state as TorchState) {
                          case TorchState.off:
                            return const Icon(Icons.flash_off, color: Colors.grey);
                          case TorchState.on:
                            return const Icon(Icons.flash_on, color: Colors.yellow);
                        }
                      },
                    ),
                    iconSize: 26.0,
                    onPressed: () => cameraController.toggleTorch(),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: ValueListenableBuilder(
                      valueListenable: cameraController.cameraFacingState,
                      builder: (context, state, child) {
                        switch (state as CameraFacing) {
                          case CameraFacing.front:
                            return const Icon(Icons.camera_front);
                          case CameraFacing.back:
                            return const Icon(Icons.camera_rear);
                        }
                      },
                    ),
                    iconSize: 26.0,
                    onPressed: () => cameraController.switchCamera(),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Center(
          child: Image(
            image: AssetImage(
              "images/camera_overlay.png",
            ),
            width: 150,
            height: 150,
          ),
        ),
      ],
    );
  }

  Widget webView() {
    return Stack(
      children: [
        BeWebView(url: urlFound, general: General(), callback: (webView) {}, onPageFinish: () {}, options: widget.options),
        backButton(),
      ],
    );
  }

  Widget contactInfo() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                contact.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getFontStyle(20, Colors.black, FontWeight.normal, widget.general),
              ),
              Text(
                contact.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getFontStyle(16, Colors.black, FontWeight.bold, widget.general),
              ),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.phone, const Icon(Icons.phone)),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.email, const Icon(Icons.email)),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.website, const Icon(Icons.link)),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.address, const Icon(Icons.pin_drop)),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.city, const Icon(Icons.location_city)),
              const SizedBox(
                height: 20,
              ),
              contactRow(contact.country, const Icon(Icons.pin_drop)),
            ],
          ),
        ),
        backButton(),
      ],
    );
  }

  Widget textInfo() {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              textMessage,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 10,
              style: getFontStyle(18, Colors.black, FontWeight.bold, widget.general),
            ),
          ),
        ),
        backButton()
      ],
    );
  }

  Widget contactRow(String text, Icon icon) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: getFontStyle(16, Colors.black, FontWeight.bold, widget.general),
            )
          ],
        ),
      ),
    );
  }

  Widget backButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
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
            if (mounted) {
              setState(() {
                cameraController = MobileScannerController();
                urlFound = "";
                textMessage = "";
                hasVCard = false;
                hasURL = false;
                hasText = false;
              });
            }
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
}
