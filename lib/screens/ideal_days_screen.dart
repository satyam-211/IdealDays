import 'package:IdealDays/helpers/FadeIndexedStack.dart';
import 'package:IdealDays/providers/day_tasks.dart';
import 'package:IdealDays/widgets/Daysometer.dart';
import 'package:IdealDays/widgets/overview.dart';

import 'package:IdealDays/widgets/recent_days.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

import '../providers/days_records.dart';

class IdealDaysScreen extends StatefulWidget {
  static const routeName = '/ideal-days';

  @override
  _IdealDaysScreenState createState() => _IdealDaysScreenState();
}

class _IdealDaysScreenState extends State<IdealDaysScreen> {
  int _currentIndex = 0;
  List<Widget> overview = [];

  void rebuild(Widget overview) {
    setState(() {
      this.overview.add(overview);
    });
  }

  Future<bool> _onBackPressed() {
    if (_currentIndex == 1 && overview.length > 1) {
      setState(() {
        this.overview.removeLast();
      });
      return Future.value(false);
    }
    return Future.value(true);
  }

  List<Widget> getWidgetList(List<DayTasks> records) {
    final groupedList = groupBy(
        records,
        (DayTasks dayTasks) =>
            DateTime(dayTasks.date.year, dayTasks.date.month)).entries.toList();
    return groupedList.reversed.map((yearWiseList) {
      return Column(
        children: [
          Flexible(
            flex: 7,
            child: GestureDetector(
              onTap: () => rebuild(RecentDays(
                recordsList: yearWiseList.value,
              )),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  border: Border.all(color: Colors.black),
                ),
                child: DaysoMeter(
                  recordsList: yearWiseList.value,
                ),
              ),
            ),
          ),
          Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${DateFormat('yMMMM').format(yearWiseList.key)}'),
              ))
        ],
      );
    }).toList();
  }

  Widget getOverview(BuildContext context, List<DayTasks> records) {
    return Overview(
      widgetList: getWidgetList(records),
      rebuild: rebuild,
    );
  }

  @override
  Widget build(BuildContext context) {
    final records =
        Provider.of<DaysRecords>(context, listen: false).recordsList;
    records.removeLast();
    if (overview.length == 0) overview.add(getOverview(context, records));
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Days'),
        ),
        body: _currentIndex == 0
            ? RecentDays(
                recordsList: records,
              )
            : Column(
                children: [
                  Expanded(
                    child: FadeIndexedStack(
                      index: overview.length - 1,
                      children: overview,
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.list), label: 'Recent Days'),
            BottomNavigationBarItem(
                icon: const Icon(Icons.graphic_eq), label: 'Overview'),
          ],
          currentIndex: _currentIndex,
          selectedItemColor: Theme.of(context).accentColor,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}
