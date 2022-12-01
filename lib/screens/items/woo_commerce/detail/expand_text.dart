import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

class ExpandText extends StatefulWidget {
  const ExpandText({
    Key? key,
    required this.labelHeader,
    required this.desc,
    required this.shortDesc,
  }) : super(key: key);

  final String labelHeader;
  final String desc;
  final String shortDesc;

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool descTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: HTML.toTextSpan(context, descTextShowFlag ? widget.desc : widget.desc),
          )
        ],
      ),
    );
  }
}
