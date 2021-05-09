import 'package:IdealDays/helpers/SwitchingDays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/days_records.dart';
import '../providers/day_tasks.dart';

import '../models/task.dart';
import '../models/Notifications.dart';

import '../widgets/category&time_choser.dart';

// ignore: must_be_immutable
class EditTasksScreen extends StatefulWidget {
  static const routeName = '/edit-tasks';
  static final _formKey = GlobalKey<FormState>();

  @override
  _EditTasksScreenState createState() => _EditTasksScreenState();
}

class _EditTasksScreenState extends State<EditTasksScreen> {
  FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();

    Notifications.init();
  }

  DayTasks _dayTasks;
  String _id;
  String _description;
  TaskType _taskType = TaskType.NewTask;
  TimeOfDay _time;
  double _percentageCompleted;

  void _setTaskType(TaskType taskType) {
    this._taskType = taskType;
  }

  void _setTime(TimeOfDay time) {
    this._time = time;
  }

  final OutlineInputBorder _outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.indigo, width: 2));

  Task createTask() {
    Task t = new Task(
        id: _id, description: _description, taskType: _taskType, time: _time);
    return t;
  }

  Future<bool> _saveTask(BuildContext context) async {
    SwitchingDays checkForDateChange = SwitchingDays(context, _dayTasks);
    if (await checkForDateChange.dateChangedReminder()) {
      if (EditTasksScreen._formKey.currentState.validate()) {
        EditTasksScreen._formKey.currentState.save();
        Task t;
        if (_id == null) {
          _id = DateFormat('9dHms').format(DateTime.now());
          t = createTask();
          await _dayTasks.addTasks(t);
        } else {
          t = createTask();
          await _dayTasks.deleteTasks(t.id);
          await _dayTasks.addTasks(t);
          t.setPercentageCompleted(_percentageCompleted);
          if (t.time != null) Notifications.deleteNotification(t.id);
        }
        if (t.time != null) Notifications.showNotification(t, _dayTasks.date);
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final task = ModalRoute.of(context).settings.arguments as Task;
    _dayTasks =
        Provider.of<DaysRecords>(context, listen: false).recordsList.last;
    if (task != null) {
      _id = task.id;
      _description = task.description;
      _taskType = task.taskType;
      _time = task.time;
      _percentageCompleted = task.percentage;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8, right: 8),
          child: Form(
            key: EditTasksScreen._formKey,
            child: Column(
              children: [
                CategoryAndTimeChoser(
                    taskType: _taskType,
                    setTaskType: _setTaskType,
                    time: _time,
                    setTime: _setTime),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Task Description',
                    border: _outlineInputBorder,
                    focusedBorder: _outlineInputBorder,
                  ),
                  initialValue: _description,
                  maxLength: 100,
                  validator: (value) {
                    if (value.isEmpty)
                      return 'Please enter the description of your Task';
                    return null;
                  },
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  onSaved: (newValue) {
                    _description = newValue;
                  },
                ),
                Builder(
                  builder: (context) => RaisedButton.icon(
                      onPressed: () async {
                        bool saved = await _saveTask(context);
                        Navigator.of(context).pop(saved);
                      },
                      icon: const Icon(
                        Icons.save,
                      ),
                      label: const Text(
                        'Save',
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
