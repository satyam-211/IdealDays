import 'dart:async';

import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:flutter/material.dart';

class MinutesCounter extends StatefulWidget {
  @override
  _MinutesCounterState createState() => _MinutesCounterState();
}

class _MinutesCounterState extends State<MinutesCounter> {
  Timer timer;
  int _notifyMeBefore = SettingsValues.notifyMeBefore;
  void decreaseBody() {
    if (_notifyMeBefore == 0) return;

    setState(() {
      _notifyMeBefore -= 1;
      SettingsValues.setNotifyMeBefore(_notifyMeBefore);
    });
  }

  void increaseBody() {
    if (_notifyMeBefore == 60) {
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Can not set notification time more than 60 minutes'),
        duration: Duration(seconds: 2),
      ));
      return;
    }
    setState(() {
      _notifyMeBefore += 1;
      SettingsValues.setNotifyMeBefore(_notifyMeBefore);
    });
  }

  GestureDetector getIcon(Icon icon, Function body) {
    return GestureDetector(
      onLongPressStart: (_) {
        timer = Timer.periodic(Duration(milliseconds: 100), (t) {
          body();
        });
      },
      onLongPressEnd: (_) {
        timer.cancel();
      },
      onTap: () {
        body();
      },
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          child: getIcon(Icon(Icons.remove), decreaseBody),
        ),
        Text(
          _notifyMeBefore.toString(),
          style: Theme.of(context).textTheme.headline2,
        ),
        Flexible(child: getIcon(Icon(Icons.add), increaseBody))
      ],
    );
  }
}
