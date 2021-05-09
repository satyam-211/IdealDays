import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'package:IdealDays/models/task.dart';
import 'package:IdealDays/providers/day_tasks.dart';
import 'package:IdealDays/providers/days_records.dart';
import 'package:IdealDays/screens/home_screen.dart';

class SwitchingDays {
  BuildContext context;
  DayTasks dayTasks;

  SwitchingDays(this.context, this.dayTasks);

  DateTime _nowDate = DateTime.now();

  Future<bool> _optionsDialog(
      String content, String button1, String button2) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Action'),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                button1,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white),
              )),
          TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(button2,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white))),
        ],
      ),
    );
  }

  Future<void> showTextDialog(String content) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Info'),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ok',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Future<DateTime> findTheDate() async {
    DateTime _date = _nowDate;
    if (await _optionsDialog(
        'Choose your new day',
        '${DateFormat('MMMd').format(_nowDate)}',
        '${DateFormat('MMMd').format(DateTime.now().add(Duration(days: 1)))}')) {
      _date = await _automaticallySkip(_date);
      await showTextDialog(
          'Setting up for ${DateFormat('MMMd').format(_date)}...');
    } else {
      _date = _date.add(Duration(days: 1));
      _date = await _automaticallySkip(_date);
      await showTextDialog(
          'Setting up for ${DateFormat('MMMd').format(_date)}...');
    }
    return _date;
  }

  Future<DateTime> _automaticallySkip(DateTime date) async {
    while (SettingsValues.weekDaysToSkip[DateFormat('EEEE').format(date)]) {
      if (await _optionsDialog("Skipping ${DateFormat('EEEE').format(date)}",
          "Continue", "Cancel")) {
        date = date.add(Duration(days: 1));
      } else {
        break;
      }
    }
    return date;
  }

  void _startNewDay(DateTime date) {
    List<Task> prevDailyTasks = dayTasks.copyDailyTasks;
    DayTasks newDay = new DayTasks(date);
    newDay.addDailyTasks(prevDailyTasks);
    DaysRecords.instance.addDayTask(newDay);
  }

  bool futureTasks(DateTime date) {
    if ((date.day > _nowDate.day &&
            date.month == _nowDate.month &&
            date.year == _nowDate.year) ||
        (date.month > _nowDate.month && date.year == _nowDate.year) ||
        (date.year > _nowDate.year)) {
      return true;
    }
    return false;
  }

  bool sameDayTasks(DateTime date) {
    if (date.day == _nowDate.day &&
        date.month == _nowDate.month &&
        date.year == _nowDate.year) {
      return true;
    }
    return false;
  }

  bool pastDayTasks(DateTime date) {
    if ((date.day < _nowDate.day &&
            date.month == _nowDate.month &&
            date.year == _nowDate.year) ||
        (date.month < _nowDate.month && date.year == _nowDate.year) ||
        (date.year < _nowDate.year)) {
      return true;
    }
    return false;
  }

  void surveyScreen() async {
    String content =
        'Do you want to save your tasks progress for ${DateFormat('MMMd').format(dayTasks.date)} and switch to the next day?';
    if (await _optionsDialog(content, 'Yes', 'No')) {
      DateTime _date = _nowDate;
      if (sameDayTasks(dayTasks.date)) {
        if (_date.hour < 20) {
          await showTextDialog(
              'Sorry, You can set new tasks for the next day only after 8pm on ${DateFormat('MMMd').format(dayTasks.date)}.');
          return;
        } else {
          _date = _date.add(Duration(days: 1));
        }
      } else if (futureTasks(dayTasks.date)) {
        await showTextDialog(
            'Sorry, we expect you not to do future tasks in present.');
        return;
      } else {
        _date = await findTheDate();
      }
      dayTasks.setPercentage();
      // var newDate = dayTasks.date.add(Duration(days: 1)); //to be removed
      _startNewDay(_date);
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.routeName, (Route<dynamic> route) => false);
    }
  }

  void skipTheDay() async {
    String content =
        'Do you really want to skip the tasks for ${DateFormat('MMMd').format(dayTasks.date)}?';
    if (await _optionsDialog(content, 'Yes', 'No')) {
      if (futureTasks(dayTasks.date)) {
        await showTextDialog(
            'You can only skip the day on the same day or after that day.');
        return;
      }
      DateTime newDayTasksDate = dayTasks.date.add(Duration(days: 1));
      if (pastDayTasks(newDayTasksDate)) {
        newDayTasksDate = _nowDate;
      }
      newDayTasksDate = await _automaticallySkip(newDayTasksDate);
      _startNewDay(newDayTasksDate);
      DaysRecords.instance.deleteDayTask(dayTasks);
      showTextDialog(
          'Skipped the day, start adding your tasks for ${DateFormat('MMMd').format(newDayTasksDate)}.');
    }
  }

  Future<void> initiateApp() async {
    DateTime _date = await findTheDate();
    DayTasks dayTasks = DayTasks(_date);
    DaysRecords.instance.addDayTask(dayTasks);
    Phoenix.rebirth(context);
  }

  Future<bool> dateChangedReminder() async {
    if (pastDayTasks(dayTasks.date)) {
      String content =
          'You are adding task for the ${DateFormat('MMMd').format(dayTasks.date)}. Complete your previous day\'s tasks survey to move to the next day.\n Continue with adding the task?';
      return _optionsDialog(content, 'Yes', 'No');
    }
    return true;
  }
}
