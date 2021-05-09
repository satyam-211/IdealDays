import 'dart:io';

import 'package:IdealDays/helpers/dayTasks_db_helper.dart';
import 'package:IdealDays/helpers/daysRecords_db_helper.dart';
import 'package:IdealDays/helpers/googleDrive.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SettingsValues {
  static int _notifyMeBefore = 5;
  static Map<String, bool> _weekDaysToSkip = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false
  };

  static void initializeValues() async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    _notifyMeBefore = prefs.getInt('notifyMeBefore') ?? 5;
    _weekDaysToSkip.keys.forEach((weekDay) =>
        _weekDaysToSkip[weekDay] = prefs.getBool(weekDay) ?? false);
  }

  static int get notifyMeBefore {
    return _notifyMeBefore;
  }

  static Map<String, bool> get weekDaysToSkip {
    return _weekDaysToSkip;
  }

  static Future<bool> changeWeekDaysToSkip(String weekDay, bool value) async {
    if ((_numDaysSkipping() < 2 && (value || !value)) ||
        (_numDaysSkipping() == 2 && !value)) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(weekDay, !_weekDaysToSkip[weekDay]);
      _weekDaysToSkip[weekDay] = !_weekDaysToSkip[weekDay];
      return true;
    }
    return false;
  }

  static void setNotifyMeBefore(int notifyMeBefore) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('notifyMeBefore', notifyMeBefore);
    _notifyMeBefore = notifyMeBefore;
  }

  static int _numDaysSkipping() {
    int count = 0;
    _weekDaysToSkip.values.forEach((value) => value ? count++ : count);
    return count;
  }

  static Future<bool> backup() async {
    var daysRecords = await DaysRecordsDB.instance.database;
    var dayTasks = await DayTasksDB.instance.database;
    GoogleDrive gd = GoogleDrive();
    gd.upload(File(daysRecords.path));
    gd.upload(File(dayTasks.path));
  }
}
