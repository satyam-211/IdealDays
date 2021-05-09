import 'package:IdealDays/providers/day_tasks.dart';
import 'package:IdealDays/widgets/DayInfo.dart';
import 'package:flutter/material.dart';

class RecentDays extends StatelessWidget {
  final List<DayTasks> recordsList;

  const RecentDays({Key key, this.recordsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recordsList.length,
      itemBuilder: (context, index) {
        return DayInfo(recordsList.elementAt(recordsList.length - 1 - index));
      },
    );
  }
}
