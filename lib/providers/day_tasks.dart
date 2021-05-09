import 'package:IdealDays/helpers/daysRecords_db_helper.dart';
import 'package:IdealDays/models/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/dayTasks_db_helper.dart';

import '../models/task.dart';

class DayTasks with ChangeNotifier {
  List<Task> _tasks = [];

  final DateTime _date;
  double _percentageCompleted;

  DayTasks(this._date) {
    DayTasksDB.tableCreate = DateFormat('_yMd').format(_date);
  }

  DateTime get date {
    return _date;
  }

  double get percentage {
    return _percentageCompleted;
  }

  void setPercentage() async {
    double tasksDoneValue = 0;
    tasks.forEach((task) => tasksDoneValue += task.percentage);
    this._percentageCompleted = tasksDoneValue / tasks.length;
    await DaysRecordsDB.instance
        .update(date.toIso8601String(), _percentageCompleted);
  }

  void percentageCompleted(double percentage) {
    this._percentageCompleted = percentage;
  }

  List<Task> get tasks {
    if (_tasks.isEmpty) return [];
    return [..._tasks];
  }

  List<Task> get dailyTasks {
    if (_tasks.isEmpty) return [];
    return tasks.where((task) => task.taskType == TaskType.DailyTask).toList();
  }

  List<Task> get newTasks {
    if (_tasks.isEmpty) return [];
    return tasks.where((task) => task.taskType == TaskType.NewTask).toList();
  }

  List<Task> get copyDailyTasks {
    return dailyTasks.map((task) {
      // String id =
      //     DateFormat('9dHms').format(DateTime.now().add(Duration(seconds: i)));
      String description = task.description;
      TimeOfDay timeOfDay = task.time;
      Task t = Task(
          id: task.id,
          description: description,
          taskType: TaskType.DailyTask,
          time: timeOfDay);
      if (task.time != null) Notifications.deleteNotification(task.id);
      return t;
    }).toList();
  }

  Future<void> addTasks(Task t) async {
    _tasks.add(t);
    await DayTasksDB.instance.insertTask({
      'id': t.id,
      'description': t.description,
      'taskType': t.taskType == TaskType.DailyTask ? 0 : 1,
      'time': t.time == null ? 'empty' : t.time.toString(),
      'percentageCompleted': t.percentage
    });
    notifyListeners();
  }

  Future<void> deleteTasks(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await DayTasksDB.instance.deleteTask(id);
    notifyListeners();
  }

  void addDailyTasks(List<Task> prevDailyTasks) {
    prevDailyTasks.forEach((task) async {
      if (task.time != null) await Notifications.showNotification(task, _date);
      await addTasks(task);
    });
  }

  Future<void> fetchAndSetTasks() async {
    final tasksList =
        await DayTasksDB.instance.getTasksFromTable(DayTasksDB.table);
    if (tasksList.isEmpty) return;
    _tasks = tasksList.map((task) {
      Task t = Task(
        id: task['id'],
        description: task['description'],
        taskType: task['taskType'] == 0 ? TaskType.DailyTask : TaskType.NewTask,
      );
      if (task['time'].toString() != 'empty') {
        String time = task['time'];
        t.alarmTime = TimeOfDay(
            hour: int.parse(time.substring(10, 12)),
            minute: int.parse(time.substring(13, 15)));
      }
      t.setPercentageCompleted(task['percentageCompleted']);
      return t;
    }).toList();
  }
}
