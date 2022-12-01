import 'dart:async';

import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/side_item.dart';
import '../../widgets/be_button.dart';

class LocationComponent extends StatefulWidget {
  const LocationComponent({Key? key, required this.item, required this.options, required this.general}) : super(key: key);
  final SideItem item;
  final AppOptions options;
  final General general;
  @override
  State<LocationComponent> createState() => _LocationComponentState();
}

class _LocationComponentState extends State<LocationComponent> {
  final Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng _center;

  @override
  void initState() {
    // TODO: implement initState
    _center = LatLng(double.parse(widget.item.latitude), double.parse(widget.item.longitude));
    super.initState();
    if (UniversalPlatform.isAndroid) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    final marker = Marker(
      markerId: const MarkerId('location'),
      position: LatLng(double.parse(widget.item.latitude), double.parse(widget.item.longitude)),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: widget.item.address,
        snippet: '',
      ),
    );
    setState(() {
      markers[const MarkerId('location')] = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: markers.values.toSet(),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(
                      widget.item.address,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: getFontStyle(15, Colors.white, FontWeight.normal, widget.general),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Positioned(
          bottom: 20,
          child: SizedBox(
            height: 44,
            child: BeButton(
              name: mainLocalization.localization.continueText,
              callback: () {
                launchMap(lat: widget.item.latitude, long: widget.item.longitude);
              },
              general: widget.general,
            ),
          ),
        ),
      ],
    );
  }

  launchMap({String lat = "47.6", String long = "-122.3"}) async {
    var mapSchema = 'geo:$lat,$long';
    if (await canLaunchUrl(Uri.parse(mapSchema))) {
      await launchUrl(Uri.parse(mapSchema));
    } else {
      throw 'Could not launch $mapSchema';
    }
  }
}
