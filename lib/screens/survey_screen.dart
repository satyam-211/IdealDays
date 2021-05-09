import 'package:IdealDays/screens/task_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/day_tasks.dart';

import '../widgets/question&slidebar.dart';

class SurveyScreen extends StatelessWidget {
  static const routeName = '/survey-screen';

  @override
  Widget build(BuildContext context) {
    List<DayTasks> recordsList = ModalRoute.of(context).settings.arguments;
    return ChangeNotifierProvider.value(
      value: recordsList.last,
      child: Builder(
        builder: (context) => Consumer<DayTasks>(
          builder: (context, todayTasks, _) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  '${DateFormat('EEEE').format(todayTasks.date)}\'s Tasks Survey',
                  style: Theme.of(context)
                      .primaryTextTheme
                      .headline6
                      .copyWith(fontWeight: FontWeight.w300),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              body: todayTasks.tasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Enter some tasks first'),
                          RaisedButton(
                            child: const Text('Go to Task Manager'),
                            onPressed: () => Navigator.of(context)
                                .popAndPushNamed(TaskManagerScreen.routeName),
                          )
                        ],
                      ),
                    )
                  : QuestionAndSlidebar(todayTasks)),
        ),
      ),
    );
  }
}
