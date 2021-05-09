import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:flutter/material.dart';

class WeekDaysList extends StatefulWidget {
  @override
  _WeekDaysListState createState() => _WeekDaysListState();
}

class _WeekDaysListState extends State<WeekDaysList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: SettingsValues.weekDaysToSkip.keys
          .map(
            (weekDay) => CheckboxListTile(
              title: Text(
                weekDay,
              ),
              dense: true,
              value: SettingsValues.weekDaysToSkip[weekDay],
              onChanged: (value) async {
                if (await SettingsValues.changeWeekDaysToSkip(weekDay, value)) {
                  Scaffold.of(context).hideCurrentSnackBar();
                  setState(() {});
                } else {
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: const Text(
                        'Not allowed to automatically skip more than two days in a week'),
                    duration: const Duration(seconds: 2),
                  ));
                }
              },
            ),
          )
          .toList(),
    );
  }
}
