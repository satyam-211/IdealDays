import 'package:flutter/material.dart';

import '../models/task.dart';

class Question extends StatelessWidget {
  final Task t;

  const Question({Key key, this.t}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.secondary),
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
                    const TextSpan(text: 'How much of the TASK  -  \n'),
                    TextSpan(
                        text: ' [ ${t.description} ] \n',
                        style: Theme.of(context)
                            .primaryTextTheme
                            .headline6
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.onPrimary)),
                    const TextSpan(text: 'did you complete ?')
                  ]),
            )),
      ],
    );
  }
}
