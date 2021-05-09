import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/day_detail_screen.dart';
import '../providers/day_tasks.dart';

class DayInfo extends StatelessWidget {
  final DayTasks _dayTask;

  const DayInfo(this._dayTask);

  @override
  Widget build(BuildContext context) {
    final value = _dayTask.percentage;
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(DayDetailScreen.routeName, arguments: _dayTask),
      child: Card(
        borderOnForeground: true,
        elevation: 4,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSecondary)),
              ),
              FractionallySizedBox(
                heightFactor: 1,
                widthFactor: _dayTask.percentage / 100,
                child: Container(
                  alignment: Alignment.center,
                  child: AutoSizeText(
                      '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}%  ${DateFormat('MMMd').format(_dayTask.date)}',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline5),
                  decoration: BoxDecoration(
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
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.arrow_forward_ios))
            ],
          ),
        ),
      ),
    );
  }
}
