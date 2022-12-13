import 'package:be_app_mobile/models/general.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFontStyle(double? fontSize, Color? color, FontWeight? fontWeight, General general) {
  if (general.fontName == "Poppins") {
    return GoogleFonts.poppins(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Roboto") {
    return GoogleFonts.roboto(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Open Sans") {
    return GoogleFonts.openSans(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Lato") {
    return GoogleFonts.lato(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Oswald") {
    return GoogleFonts.oswald(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Montserrat") {
    return GoogleFonts.montserrat(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Merriweather") {
    return GoogleFonts.merriweather(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Playfair Display") {
    return GoogleFonts.playfairDisplay(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Lora") {
    return GoogleFonts.lora(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Bebas Neue") {
    return GoogleFonts.bebasNeue(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Lobster") {
    return GoogleFonts.lobster(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Comfortaa") {
    return GoogleFonts.comfortaa(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Pacifico") {
    return GoogleFonts.pacifico(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Inconsolata") {
    return GoogleFonts.inconsolata(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "IBM Plex Mono") {
    return GoogleFonts.ibmPlexMono(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Slabo 27px") {
    return GoogleFonts.slabo27px(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Slabo 13px") {
    return GoogleFonts.slabo13px(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Nunito Sans") {
    return GoogleFonts.nunitoSans(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Work Sans") {
    return GoogleFonts.workSans(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Inknut Antiqua") {
    return GoogleFonts.inknutAntiqua(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Neuton") {
    return GoogleFonts.neuton(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Neucha") {
    return GoogleFonts.neucha(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Manrope") {
    return GoogleFonts.manrope(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Arvo") {
    return GoogleFonts.arvo(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Archivo") {
    return GoogleFonts.archivo(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Alice") {
    return GoogleFonts.alice(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else if (general.fontName == "Inter") {
    return GoogleFonts.inter(fontSize: fontSize, color: color, fontWeight: fontWeight);
  } else {
    return GoogleFonts.roboto(fontSize: fontSize, color: color, fontWeight: fontWeight);
  }
}
