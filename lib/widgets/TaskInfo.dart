import 'package:IdealDays/providers/day_tasks.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../models/Notifications.dart';
import '../screens/edit_tasks_screen.dart';

class TaskInfo extends StatelessWidget {
  final Task t;
  final DayTasks todayTasks;

  const TaskInfo(this.t, this.todayTasks);

  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(t.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async => await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Action'),
          content: const Text('Do you want to delete this task'),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white))),
            FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white))),
          ],
        ),
      ),
      onDismissed: (_) async {
        await todayTasks.deleteTasks(t.id);
        await Notifications.deleteNotification(t.id);
      },
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
              0.1,
              0.3,
              0.7,
              1
            ],
                colors: [
              Colors.lightBlue,
              Colors.blueAccent,
              Colors.blue,
              Colors.indigo
            ])),
        child: ListTile(
          dense: true,
          leading: Container(
            padding: const EdgeInsets.all(3),
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(2, 6)),
                border: Border.all(color: Theme.of(context).primaryColor)),
            child: Text(
              t.time != null ? '${t.time.format(context)}' : 'AnyTime',
              textAlign: TextAlign.center,
              style: Theme.of(context).primaryTextTheme.headline4.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          title: Text(
            t.description,
            textAlign: TextAlign.start,
            style: Theme.of(context).inputDecorationTheme.labelStyle,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => Navigator.of(context)
                .pushNamed(EditTasksScreen.routeName, arguments: t),
          ),
        ),
      ),
    );
  }
}
