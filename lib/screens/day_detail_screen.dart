import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/day_tasks.dart';

class DayDetailScreen extends StatelessWidget {
  static const routeName = '/day_details';

  String completionStatus(double value) {
    if (value == 0)
      return 'did not complete';
    else if (value == 25)
      return 'partially completed';
    else if (value == 50)
      return 'completed half of';
    else if (value == 75)
      return 'almost completed';
    else if (value == 100)
      return 'fully completed';
    else
      return '$value';
  }

  @override
  Widget build(BuildContext context) {
    final _dayTask = ModalRoute.of(context).settings.arguments as DayTasks;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('${DateFormat('MMMd').format(_dayTask.date)} Tasks Details'),
      ),
      body: ListView.builder(
        itemCount: _dayTask.tasks.length,
        itemBuilder: (context, index) {
          var tasks = _dayTask.tasks;
          return Card(
            elevation: 4,
            borderOnForeground: true,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Theme.of(context)
                            .inputDecorationTheme
                            .labelStyle
                            .color,
                      ),
                  children: [
                    const TextSpan(text: 'You  '),
                    TextSpan(
                        text:
                            '${completionStatus(tasks.elementAt(index).percentage)} ',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                fontWeight: FontWeight.w300,
                                color: Theme.of(context)
                                    .inputDecorationTheme
                                    .labelStyle
                                    .color)),
                    const TextSpan(text: 'the task -\n'),
                    TextSpan(
                        text: ' [ ${tasks.elementAt(index).description} ] \n',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                  ]),
            ),
          );
        },
      ),
    );
  }
}
