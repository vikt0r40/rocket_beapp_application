import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:flutter/material.dart';

class BeButton extends StatefulWidget {
  final String name;
  final Function callback;
  final bool? whiteMode;
  final General general;
  const BeButton({Key? key, required this.name, required this.callback, this.whiteMode, required this.general}) : super(key: key);

  @override
  _BeButtonState createState() => _BeButtonState();
}

class _BeButtonState extends State<BeButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            widget.callback();
          },
          style: ElevatedButton.styleFrom(primary: widget.whiteMode ?? false ? Colors.white : Theme.of(context).secondaryHeaderColor),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.name,
              style: widget.whiteMode ?? false
                  ? getFontStyle(14, Colors.black, FontWeight.normal, widget.general)
                  : getFontStyle(14, Colors.white, FontWeight.normal, widget.general),
            ),
          ),
        ));
  }
}
