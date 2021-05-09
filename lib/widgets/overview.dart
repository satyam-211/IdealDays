import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  final List<Widget> widgetList;
  final Function rebuild;

  const Overview({Key key, this.rebuild, this.widgetList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return widgetList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: widgetList,
            ),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No daily tasks data for overview'),
              ],
            ),
          );
  }
}
