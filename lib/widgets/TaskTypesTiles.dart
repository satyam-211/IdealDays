import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/TaskInfo.dart';

import '../providers/day_tasks.dart';

class TaskTypesTiles extends StatelessWidget {
  final List<DayTasks> recordsList;
  const TaskTypesTiles(this.recordsList);
  Widget taskTiles(BuildContext context, DayTasks tasks) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text(
            'Daily Tasks',
          ),
          children: tasks != null
              ? tasks.dailyTasks.map((task) => TaskInfo(task, tasks)).toList()
              : [],
          initiallyExpanded: true,
        ),
        ExpansionTile(
          title: const Text(
            'New Tasks',
          ),
          children: tasks != null
              ? tasks.newTasks.map((task) => TaskInfo(task, tasks)).toList()
              : [],
          initiallyExpanded: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return recordsList.isNotEmpty
        ? ChangeNotifierProvider.value(
            value: recordsList.last,
            child: SingleChildScrollView(
              child: Consumer<DayTasks>(
                builder: (context, tasks, _) => taskTiles(context, tasks),
              ),
            ),
          )
        : taskTiles(context, null);
  }
}
