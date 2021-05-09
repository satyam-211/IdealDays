import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';

import '../helpers/dayTasks_db_helper.dart';

enum TaskType { DailyTask, NewTask }

class Task {
  final String id;
  final String description;
  final TaskType taskType;
  TimeOfDay time;
  double _percentageCompleted = 0.0;

  Task(
      {@required this.id,
      @required this.description,
      @required this.taskType,
      this.time});

  void setPercentageCompleted(double percentage) {
    this._percentageCompleted = percentage;
    DayTasksDB.instance.update(id, _percentageCompleted);
  }

  double get percentage {
    return this._percentageCompleted;
  }

  set alarmTime(TimeOfDay time) {
    this.time = time;
  }

  bool operator ==(o) =>
      o is Task &&
      (o.description.trim().toLowerCase().split(' ').join('') ==
              description.trim().toLowerCase().split(' ').join('') ||
          o.id == id) &&
      o.taskType == taskType;

  int get hashCode => time.hashCode;
}
