import 'package:flutter/material.dart';

import '../models/task.dart';

// ignore: must_be_immutable
class CategoryAndTimeChoser extends StatefulWidget {
  TaskType taskType;
  final Function setTaskType;
  TimeOfDay time;
  final Function setTime;

  CategoryAndTimeChoser(
      {@required this.taskType,
      @required this.setTaskType,
      @required this.time,
      @required this.setTime});

  @override
  _CategoryAndTimeChoserState createState() => _CategoryAndTimeChoserState();
}

class _CategoryAndTimeChoserState extends State<CategoryAndTimeChoser> {
  Future<Null> setTime(BuildContext context) async {
    TimeOfDay pickedTime = await showTimePicker(
        context: context, initialTime: widget.time ?? TimeOfDay.now());
    if (pickedTime == null) return;
    setState(() {
      widget.time = pickedTime;
    });
    widget.setTime(pickedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: RadioListTile(
                title: const Text(
                  'Daily Task',
                ),
                value: TaskType.DailyTask,
                groupValue: widget.taskType,
                onChanged: (val) {
                  setState(() {
                    widget.taskType = val;
                    widget.setTaskType(val);
                  });
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: const Text('New Task'),
                value: TaskType.NewTask,
                groupValue: widget.taskType,
                onChanged: (val) {
                  setState(() {
                    widget.taskType = val;
                    widget.setTaskType(val);
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.time != null
                ? Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black38),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.elliptical(2, 4)),
                    ),
                    child: Text(
                      '${widget.time.format(context)}',
                      style: Theme.of(context).primaryTextTheme.headline6,
                    ))
                : Text(
                    'No Time Chosen',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
            RaisedButton.icon(
                onPressed: () => setTime(context),
                icon: const Icon(Icons.alarm_add),
                label: const Text('Set Time')),
          ],
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
