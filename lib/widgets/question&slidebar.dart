import 'package:flutter/material.dart';

import '../providers/day_tasks.dart';

import '../widgets/question.dart';
import '../widgets/slidebar.dart';
import '../helpers/SwitchingDays.dart';

class QuestionAndSlidebar extends StatefulWidget {
  final DayTasks todayTasks;

  const QuestionAndSlidebar(this.todayTasks);

  @override
  _QuestionAndSlidebarState createState() => _QuestionAndSlidebarState();
}

class _QuestionAndSlidebarState extends State<QuestionAndSlidebar> {
  int taskIndex = 0;
  bool goneForward = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset(goneForward ? 1 : -1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
      child: Column(
        key: ValueKey(taskIndex),
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Question(
            t: widget.todayTasks.tasks.elementAt(taskIndex),
          ),
          SlideBar(
            t: widget.todayTasks.tasks.elementAt(taskIndex),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: taskIndex != 0
                        ? () => setState(() {
                              goneForward = false;
                              taskIndex -= 1;
                            })
                        : null),
              ),
              if (taskIndex == widget.todayTasks.tasks.length - 1)
                RaisedButton.icon(
                    onPressed: () {
                      SwitchingDays _switchDay =
                          SwitchingDays(context, widget.todayTasks);
                      _switchDay.surveyScreen();
                    },
                    icon: const Icon(
                      Icons.open_in_new,
                    ),
                    label: const Text(
                      'New Day',
                    )),
              Container(
                margin: const EdgeInsets.all(20),
                child: IconButton(
                    color: Theme.of(context).accentColor,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    onPressed: taskIndex != widget.todayTasks.tasks.length - 1
                        ? () => setState(() {
                              goneForward = true;
                              taskIndex += 1;
                            })
                        : null),
              )
            ],
          )
        ],
      ),
    );
  }
}
