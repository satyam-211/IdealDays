import 'package:IdealDays/helpers/SwitchingDays.dart';
import 'package:IdealDays/providers/days_records.dart';
import 'package:IdealDays/screens/ideal_days_screen.dart';
import 'package:IdealDays/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:provider/provider.dart';
import 'survey_screen.dart';
import 'task_manager_screen.dart';

import '../widgets/Daysometer.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.35;
    void _initiateApp() async {
      SwitchingDays _switchDay = SwitchingDays(context, null);
      await _switchDay.initiateApp();
    }

    final records = Provider.of<DaysRecords>(context).recordsList;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ideal Days'),
        elevation: 0,
        actions: [
          if (records.isNotEmpty)
            IconButton(
                icon: Icon(Icons.settings_applications),
                onPressed: () => Navigator.of(context)
                    .pushNamed(TaskManagerScreen.routeName))
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: DrawerHeader(
                child: Text('Ideal Days',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .primaryTextTheme
                        .headline3
                        .copyWith(color: Colors.white)),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).accentColor,
              ),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.headline6,
              ),
              trailing: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).accentColor,
              ),
              onTap: () =>
                  Navigator.of(context).pushNamed(SettingsScreen.routeName),
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              if (records.length > 1)
                CircularText(
                  radius: height * 0.52,
                  position: CircularTextPosition.outside,
                  children: [
                    TextItem(
                      text: Text(
                        'You are living on average',
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                      direction: CircularTextDirection.clockwise,
                      space: 6,
                      startAngle: -90,
                      startAngleAlignment: StartAngleAlignment.center,
                    ),
                    TextItem(
                      text: Text(
                        'of your Ideal Days',
                        style: Theme.of(context).primaryTextTheme.bodyText2,
                      ),
                      direction: CircularTextDirection.anticlockwise,
                      space: 6,
                      startAngle: 90,
                      startAngleAlignment: StartAngleAlignment.center,
                    )
                  ],
                ),
              GestureDetector(
                onTap: records.length > 1
                    ? () => Navigator.of(context)
                        .pushNamed(IdealDaysScreen.routeName)
                    : null,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(height),
                    child: Container(
                      height: height,
                      width: height,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        border: Border.all(color: Colors.black),
                      ),
                      child: records.length <= 1
                          ? const Align(
                              alignment: Alignment.center,
                              child: Text(
                                ' You haven\'t added any Ideal Day :( ',
                                textAlign: TextAlign.center,
                              ),
                            )
                          : DaysoMeter(
                              recordsList: records
                                  .getRange(0, records.length - 1)
                                  .toList(),
                            ),
                    )),
              ),
            ]),
            if (records.isEmpty)
              RaisedButton(
                child: const Text('Start Recording Your Days'),
                padding: const EdgeInsets.only(left: 8, right: 8),
                onPressed: _initiateApp,
              ),
            if (records.isNotEmpty)
              RaisedButton.icon(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  onPressed: () => Navigator.of(context)
                      .pushNamed(SurveyScreen.routeName, arguments: records),
                  icon: const Icon(Icons.arrow_forward_ios),
                  label: const Text('Update Me')),
            if (records.isNotEmpty)
              RaisedButton(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  onPressed: () {
                    SwitchingDays _switchingDay =
                        SwitchingDays(context, records.last);
                    _switchingDay.skipTheDay();
                  },
                  child: const Text('Skip the day')),
          ],
        ),
      ),
    );
  }
}
