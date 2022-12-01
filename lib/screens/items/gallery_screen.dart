import 'dart:math';

import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/widgets/be_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../models/general.dart';
import 'fullscreen_image.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key, required this.options, required this.general}) : super(key: key);
  final AppOptions options;
  final General general;
  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StaggeredGrid.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            children: photosWidgets(),
          ),
        ),
      ),
    );
  }

  List<Widget> photosWidgets() {
    List<Widget> items = List.generate(widget.options.imageUrls.length, (index) {
      double start = 1;
      double end = 2.0;
      double random = Random().nextDouble();
      double result = start + (random * (end - start));
      return StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: result,
        child: Container(
          decoration: const BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(15))),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    opaque: false,
                    barrierColor: Colors.black,
                    pageBuilder: (BuildContext context, _, __) {
                      return FullScreenPage(
                        imageChild: BeImage(
                          link: widget.options.imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                        dark: true,
                        imageUrl: widget.options.imageUrls[index],
                        general: widget.general,
                      );
                    },
                  ),
                );
              },
              child: BeImage(
                link: widget.options.imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    });
    return items;
  }
}
