import 'package:be_app_mobile/app/splash_app.dart';
import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/custom_localization.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/widgets/be_button.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';

import '../widgets/be_dropdown.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({Key? key, required this.model, required this.onLanguageSelected}) : super(key: key);
  final BeAppModel model;
  final Function onLanguageSelected;
  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  List<String> languageNames = [];
  int selectedDropIndex = 0;
  String selectedLanguage = "";

  @override
  void initState() {
    // TODO: implement initState
    for (CustomLocalization local in widget.model.options.customLocalizations) {
      languageNames.add(local.name);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.model.general.getApplicationColor(),
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/language_image.png",
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BeImage(
                      link: widget.model.general.logoUrl,
                      width: 170,
                      height: 170,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.model.options.localization.pickLanguage,
                          style: getFontStyle(22, Colors.black, FontWeight.bold, widget.model.general),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BeDropdown(
                        title: "Select Language",
                        items: languageNames,
                        callback: (value) {
                          setState(() {
                            selectedLanguage = value ?? "";
                            for (int i = 0; i < languageNames.length; i++) {
                              String name = languageNames[i];
                              if (name == value) {
                                selectedDropIndex = i;
                                break;
                              }
                            }
                            widget.model.options.localization = widget.model.options.customLocalizations[selectedDropIndex].localization;
                          });
                        },
                        selectedValue: ""),
                    const SizedBox(
                      height: 50,
                    ),
                    BeButton(
                        name: widget.model.options.localization.languageButton,
                        callback: () {
                          MySharedPreferences.instance.setBooleanValue("isLanguageSelected", true);
                          widget.onLanguageSelected(widget.model.options.customLocalizations[selectedDropIndex].localization);
                          mainLocalization = widget.model.options.customLocalizations[selectedDropIndex];
                          isRTL = mainLocalization.isRTL;
                          MySharedPreferences.instance.setBooleanValue("isRTL", mainLocalization.isRTL);
                          MySharedPreferences.instance.setSelectedLanguage(selectedDropIndex);
                        },
                        general: widget.model.general)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
