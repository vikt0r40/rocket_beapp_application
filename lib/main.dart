import 'package:be_app_mobile/app/service_widget.dart';
import 'package:be_app_mobile/offline_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  OfflineSettings settings = OfflineSettings();
  if (settings.enableOfflineMode == false) {
    await Firebase.initializeApp();
  }

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterDownloader.initialize(debug: true);

  runApp(MaterialApp(
    color: Colors.black,
    theme: ThemeData(
      primaryColor: Colors.white,
      secondaryHeaderColor: Colors.black87,
      textTheme: TextTheme(
        headline1: GoogleFonts.poppins(fontSize: 20, color: Colors.black87),
        headline2: GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
        headline3: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
        headline4: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        headline5: GoogleFonts.poppins(fontSize: 12, color: Colors.black87),
        headline6: GoogleFonts.poppins(fontSize: 25, color: Colors.black87, fontWeight: FontWeight.bold),
        bodyText1: GoogleFonts.poppins(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.bold),
        bodyText2: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
        caption: GoogleFonts.poppins(fontSize: 22, color: Colors.black87),
        button: GoogleFonts.poppins(fontSize: 14, color: Colors.white),
      ),
    ),
    home: const ServiceWidget(),
    debugShowCheckedModeBanner: false,
  ));
}
