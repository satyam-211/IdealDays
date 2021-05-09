import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:IdealDays/widgets/minutesCounter.dart';
import 'package:IdealDays/widgets/weekDaysList.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Flexible(child: const Text('Notify me about a task before:')),
                  Flexible(child: MinutesCounter()),
                  const Text('minutes')
                ],
              ),
            ),
            Divider(),
            Card(
              child: Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Week Days To Skip',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            Divider(),
            WeekDaysList(),
            RaisedButton.icon(
              icon: Icon(Icons.backup),
              label: Text('Backup Data'),
              onPressed: () => SettingsValues.backup(),
            )
          ],
        ),
      ),
    );
  }
}
