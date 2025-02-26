import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
class Dateformat {
  static String formatWorkingDate(String dateStr) {
    try {
      DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
      DateTime parsedDate = dateFormat.parse(dateStr);
      return DateFormat('dd-MM-yyyy HH:mm:ss').format(parsedDate);
    } catch (e) {
      print("Error parsing date: $e");
      return 'Invalid date';
    }
  }
}
