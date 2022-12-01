import 'package:flutter/material.dart';
import 'package:simple_html_css/simple_html_css.dart';

import '../../../models/side_item.dart';

class TextComponent extends StatelessWidget {
  const TextComponent({Key? key, required this.item}) : super(key: key);
  final SideItem item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RichText(
            text: HTML.toTextSpan(context, item.text),
          ),
        ),
      ),
    );
  }
}
