import 'package:flutter/material.dart';
import 'package:sosyal_medya/extension/dynamic_extensions.dart';
import 'package:sosyal_medya/pages/working_life/working_life_view.dart';

abstract class WorkingLifeViewModel extends State<WorkingLifeView> {
  DynamicViewExtensions dynamicViewExtensions = DynamicViewExtensions();

  String calculateDateDifference(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      return 'Geçersiz Tarih Aralığı';
    }

    int years = end.year - start.year;
    int months = end.month - start.month;
    int days = end.day - start.day;

    if (days < 0) {
      months -= 1;
      final prevMonth = DateTime(end.year, end.month, 0);
      days += prevMonth.day;
    }

    if (months < 0) {
      years -= 1;
      months += 12;
    }

    String result = '';
    if (years > 0) result += '$years Yıl ';
    if (months > 0) result += '$months Ay ';
    if (days > 0) result += '$days Gün';

    return result.trim().isEmpty ? 'Aynı Gün' : result.trim();
  }
}
