import 'package:IdealDays/helpers/SettingsValues.dart';
import 'package:IdealDays/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'screens/home_screen.dart';
import 'screens/ideal_days_screen.dart';
import 'screens/day_detail_screen.dart';
import 'screens/task_manager_screen.dart';
import 'screens/survey_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/edit_tasks_screen.dart';

import 'providers/days_records.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  DaysRecords daysRecordsInstance = DaysRecords.instance;
  runApp(Phoenix(
    child: ChangeNotifierProvider.value(
        value: daysRecordsInstance, child: MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<DaysRecords>(context, listen: false)
            .fetchAndSetRecordsList(),
        builder: (context, snapshot) {
          SettingsValues.initializeValues();
          return MaterialApp(
            title: 'Ideal Days',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                scaffoldBackgroundColor: Colors.white,
                primaryColor: Colors.white,
                accentColor: Colors.indigo,
                appBarTheme: AppBarTheme(
                  color: Colors.white,
                  iconTheme: IconThemeData(
                    color: Colors.indigo,
                  ),
                ),
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(onPrimary: Colors.red, onSecondary: Colors.white),
                timePickerTheme: TimePickerThemeData(
                  dialBackgroundColor: Colors.grey[400],
                ),
                primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
                    fontFamily: 'SansitaSwashed',
                    bodyColor: Colors.indigo,
                    displayColor: Colors.indigo),
                textTheme: Theme.of(context).textTheme.apply(
                    fontFamily: 'Comfortaa',
                    bodyColor: Colors.indigo,
                    displayColor: Colors.black54),
                floatingActionButtonTheme:
                    Theme.of(context).floatingActionButtonTheme.copyWith(
                          backgroundColor: Colors.indigo,
                        ),
                dialogTheme: DialogTheme(
                    backgroundColor: Colors.indigo,
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                    contentTextStyle: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white)),
                buttonTheme: ButtonThemeData(
                    textTheme: ButtonTextTheme.primary,
                    buttonColor: Colors.indigo),
                inputDecorationTheme: InputDecorationTheme(
                    labelStyle: TextStyle(color: Colors.black87))),
            home: snapshot.connectionState == ConnectionState.waiting
                ? LoadingScreen()
                : HomeScreen(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case HomeScreen.routeName:
                  return PageTransition(
                    child: HomeScreen(),
                    type: PageTransitionType.fade,
                    settings: settings,
                  );
                  break;
                case TaskManagerScreen.routeName:
                  return PageTransition(
                    child: TaskManagerScreen(),
                    type: PageTransitionType.topToBottom,
                    settings: settings,
                  );
                  break;
                case EditTasksScreen.routeName:
                  return PageTransition(
                    child: EditTasksScreen(),
                    type: PageTransitionType.bottomToTop,
                    settings: settings,
                  );
                  break;
                case SettingsScreen.routeName:
                  return PageTransition(
                    child: SettingsScreen(),
                    type: PageTransitionType.rightToLeft,
                    settings: settings,
                  );
                  break;
                case IdealDaysScreen.routeName:
                  return PageTransition(
                    child: IdealDaysScreen(),
                    type: PageTransitionType.size,
                    alignment: Alignment.center,
                    settings: settings,
                  );
                  break;
                case DayDetailScreen.routeName:
                  return PageTransition(
                    child: DayDetailScreen(),
                    type: PageTransitionType.rightToLeftWithFade,
                    settings: settings,
                  );
                  break;
                case SurveyScreen.routeName:
                  return PageTransition(
                    child: SurveyScreen(),
                    type: PageTransitionType.fade,
                    settings: settings,
                  );
                  break;
                default:
                  return null;
              }
            },
          );
        });
  }
}
