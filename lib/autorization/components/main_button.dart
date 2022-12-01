import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:flutter/material.dart';

import '../helpers/font_size.dart';
import '../helpers/theme_colors.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final String? iconPath;
  final Function() onTap;
  final General general;
  const MainButton({Key? key, required this.text, this.backgroundColor, this.textColor, required this.onTap, this.iconPath, required this.general})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? ThemeColors.primaryColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconPath == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Image(
                        image: AssetImage(iconPath!),
                        height: 30,
                      ),
                    ),
              Text(
                text,
                style: getFontStyle(FontSize.medium, textColor ?? ThemeColors.whiteTextColor, FontWeight.bold, general),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
