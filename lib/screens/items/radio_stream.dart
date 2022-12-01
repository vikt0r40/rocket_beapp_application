import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radio_player/radio_player.dart';

import '../../models/general.dart';
import '../../models/side_item.dart';

class RadioStream extends StatefulWidget {
  const RadioStream({Key? key, required this.item, required this.general}) : super(key: key);
  final SideItem item;
  final General general;

  @override
  State<RadioStream> createState() => _RadioStreamState();
}

class _RadioStreamState extends State<RadioStream> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url: widget.item.link,
      //imagePath: 'images/app_icon.png',
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      print(value);
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black87,
        body: Center(
          child: Stack(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: _radioPlayer.getArtworkImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Image artwork;
                  if (snapshot.hasData) {
                    artwork = snapshot.data;
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: artwork,
                      ),
                    );
                  } else {
                    return Container(
                      color: widget.general.getApplicationColor(),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.music,
                            size: 120,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            widget.item.title,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                            style: getFontStyle(24, Colors.black, FontWeight.bold, widget.general),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.black.withOpacity(0.4),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        metadata?[0] ?? '',
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: getFontStyle(24, Colors.white, FontWeight.bold, widget.general),
                      ),
                      Text(
                        metadata?[1] ?? '',
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: getFontStyle(16, Colors.white, FontWeight.bold, widget.general),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: Colors.white, // <-- Button color
                          onPrimary: Colors.white, // <-- Splash color
                        ),
                        child: FaIcon(
                          isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
