import 'package:flutter/material.dart';

import '../models/task.dart';

class SlideBar extends StatefulWidget {
  final Task t;

  const SlideBar({Key key, this.t}) : super(key: key);

  @override
  _SlideBarState createState() => _SlideBarState();
}

class _SlideBarState extends State<SlideBar> {
  var value;

  String get label {
    if (value == 0)
      return 'Nothing';
    else if (value == 25)
      return 'Partially completed';
    else if (value == 50)
      return 'Half Completed';
    else if (value == 75)
      return 'Almost completed';
    else if (value == 100)
      return 'Fully completed';
    else
      return '$value';
  }

  @override
  Widget build(BuildContext context) {
    value = widget.t.percentage ?? 0;
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: const BorderRadius.all(Radius.elliptical(4, 8)),
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
                Colors.blueGrey[50],
                Colors.blueGrey[100],
                Colors.blueGrey[200],
                Colors.blueGrey[400],
              ])),
      child: SliderTheme(
        data: SliderThemeData(
            valueIndicatorColor: Colors.transparent,
            valueIndicatorTextStyle: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.w300, fontSize: 16)),
        child: Slider(
          min: 0,
          max: 100,
          activeColor: Theme.of(context).accentColor,
          value: value,
          divisions: 4,
          autofocus: true,
          onChanged: (newValue) {
            setState(() {
              widget.t.setPercentageCompleted(newValue);
            });
          },
          label: label,
        ),
      ),
    );
  }
}
