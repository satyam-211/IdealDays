import 'package:IdealDays/models/task.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';

class DaysoMeter extends StatelessWidget {
  final List<dynamic> recordsList;

  const DaysoMeter({Key key, this.recordsList}) : super(key: key);

  double get idealDaysPercentageCalc {
    double daysTasksDoneValue = 0;
    recordsList.forEach((record) {
      if (record.percentage != null) daysTasksDoneValue += record.percentage;
    });
    return (daysTasksDoneValue / recordsList.length);
  }

  @override
  Widget build(BuildContext context) {
    double idealDaysPercentage = idealDaysPercentageCalc;
    if (recordsList is List<Task>) {
      double day = (100 / idealDaysPercentage);
      return Tooltip(
          message:
              'You complete this task every ${day == 1 ? '' : day.toStringAsFixed(day.truncateToDouble() == day ? 0 : 1)} day',
          decoration: const BoxDecoration(color: Colors.black54),
          preferBelow: true,
          child: widget(idealDaysPercentage, context));
    }
    return widget(idealDaysPercentage, context);
  }

  Stack widget(double idealDaysPercentage, BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FractionallySizedBox(
          heightFactor: idealDaysPercentage / 100 ?? 0.0,
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).accentColor),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  '${idealDaysPercentage.toStringAsFixed(idealDaysPercentage.truncateToDouble() == idealDaysPercentage ? 0 : 2)}%',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Flexible(
                  child: Text(
                    recordsList.length != 1
                        ? '(${recordsList.length} days)'
                        : '(${recordsList.length} day)',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(color: Colors.black54),
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
