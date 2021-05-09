import 'package:IdealDays/helpers/dayTasks_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'day_tasks.dart';
import '../helpers/daysRecords_db_helper.dart';

class DaysRecords with ChangeNotifier {
  static List<DayTasks> _record = [];

  DaysRecords._privateConstructor();
  static final DaysRecords instance = DaysRecords._privateConstructor();

  List<DayTasks> get recordsList {
    return [..._record];
  }

  void addDayTask(DayTasks dayTask) {
    _record.add(dayTask);
    DaysRecordsDB.instance.insertDayTask({
      'id': dayTask.date.toIso8601String(),
      'tasks': DateFormat('_yMd').format(dayTask.date),
      'percentageCompleted': dayTask.percentage ?? 0
    });
    notifyListeners();
  }

  void deleteDayTask(DayTasks dayTask) {
    _record.remove(dayTask);
    String tableName = DateFormat('_yMd').format(dayTask.date);
    DayTasksDB.instance.deleteTable(tableName);
    DaysRecordsDB.instance.deleteDayTask(tableName);
  }

  Future<void> fetchAndSetRecordsList() async {
    final daysRecordsList = await DaysRecordsDB.instance.getDayTasks();
    if (daysRecordsList.isEmpty) return;
    _record = daysRecordsList.map((dayTask) {
      DayTasks dt = DayTasks(DateTime.parse(dayTask['id']));
      dt.percentageCompleted(dayTask['percentageCompleted']);
      dt.fetchAndSetTasks();
      return dt;
    }).toList();
  }
}
