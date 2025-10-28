import 'package:flutter/material.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/education_information/education_information_view.dart';

abstract class EducationInformationViewModel extends State<EducationInformationView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  // Ülke kodundan bayrak emojisi oluştur
  String getCountryFlag(String countryCode) {
    // Ülke kodunu büyük harfe çevir (TR, US, DE, vb.)
    final code = countryCode.toUpperCase();

    // Her harf için Unicode regional indicator symbol oluştur
    // A = 🇦 (U+1F1E6), B = 🇧 (U+1F1E7), vb.
    return code.runes.map((rune) {
      // A-Z arasındaki harfleri regional indicator'a çevir
      if (rune >= 0x41 && rune <= 0x5A) {
        return String.fromCharCode(0x1F1E6 + (rune - 0x41));
      }
      return String.fromCharCode(rune);
    }).join();
  }
}
