import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_tracker_pro/model/priority.dart';

class Utils {
  static DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
  static DateFormat formatterDate = DateFormat('yyyy-MM-dd');

  static String convertDateToString(DateTime dateTime,
      {bool isFormatDate = false}) {
    if (isFormatDate) {
      return formatterDate.format(dateTime);
    } else {
      return formatter.format(dateTime);
    }
  }

  static bool isDateToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
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

  static String formatTimeAgo(String datetime) {
    DateTime time = DateTime.parse(datetime);
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 5) {
      return 'a few seconds ago';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes == 1) {
      return 'a minute ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours == 1) {
      return 'an hour ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'a day ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = difference.inDays ~/ 365;
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }
}
