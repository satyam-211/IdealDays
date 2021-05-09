import 'package:IdealDays/models/task.dart';
import 'package:IdealDays/providers/day_tasks.dart';
import 'package:IdealDays/providers/days_records.dart';
import 'package:IdealDays/widgets/Daysometer.dart';

import 'package:IdealDays/widgets/overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import '../widgets/TaskTypesTiles.dart';
import 'edit_tasks_screen.dart';

// ignore: must_be_immutable
class TaskManagerScreen extends StatefulWidget {
  static const routeName = '/task-manager';

  @override
  _TaskManagerScreenState createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  int _currentIndex = 0;
  bool sortByName = false;

  void _showEditScreen(BuildContext context) async {
    var saved =
        await Navigator.of(context).pushNamed(EditTasksScreen.routeName);
    if (saved == null) return;
    if (saved) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Added a task'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  getGroupedList(List<DayTasks> recordsList) {
    List<Task> allTasks = [];
    recordsList.removeLast();
    recordsList.forEach((record) => allTasks.addAll(record.tasks));
    allTasks.retainWhere((task) =>
        task.taskType == TaskType.DailyTask &&
        recordsList.last.dailyTasks.indexOf(task) != -1);
    return groupBy(allTasks,
            (Task task) => sortByName ? task.description.trim() : task)
        .entries
        .toList();
  }

  List<Widget> getWidgetList(BuildContext context, List<DayTasks> records) {
    final List<MapEntry<dynamic, List<Task>>> groupedList =
        getGroupedList(records);
    return groupedList.reversed
        .map((taskWiseList) => Column(
              children: [
                Flexible(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Colors.black),
                    ),
                    child: DaysoMeter(
                      recordsList: taskWiseList.value,
                    ),
                  ),
                ),
                Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${taskWiseList.value.last.description.trim()}',
                        overflow: TextOverflow.visible,
                      ),
                    ))
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final records = Provider.of<DaysRecords>(context).recordsList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          if (_currentIndex == 1)
            PopupMenuButton(
              child: Icon(Icons.filter_alt),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: CheckboxListTile(
                  title: Text('Sort By Name'),
                  value: sortByName,
                  onChanged: (value) {
                    Navigator.of(context).pop();
                    setState(() {
                      sortByName = value;
                    });
                  },
                ))
              ],
            ),
        ],
      ),
      body: _currentIndex == 0
          ? TaskTypesTiles(records)
          : Overview(
              widgetList: getWidgetList(context, records),
            ),
      floatingActionButton: _currentIndex == 0
          ? Builder(
              builder: (context) => FloatingActionButton.extended(
                onPressed: () {
                  _showEditScreen(context);
                },
                label: const Text(
                  'Add Tasks',
                ),
                autofocus: false,
                clipBehavior: Clip.none,
                icon: const Icon(
                  Icons.add,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.segment), label: 'Manage Tasks'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.work), label: 'Daily Tasks Overview'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
