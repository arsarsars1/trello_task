import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_pro/model/priority.dart';

class Utils {
  static DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

  static String convertDateToString(DateTime dateTime) {
    return formatter.format(dateTime);
  }

  static DateTime convertStringToDate(String dateTime) {
    return DateTime.parse(dateTime);
  }

  static String convertDateString(String dateTime) {
    return formatter.format(DateTime.parse(dateTime));
  }

  static int generateRandomId({int min = 100000, int max = 999999}) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  static Color getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.High:
        return Colors.red;
      case Priority.Medium:
        return Colors.orange;
      case Priority.Low:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
