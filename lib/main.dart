import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kiscon_crawler_client/src/provider/state_provider.dart';
import 'package:kiscon_crawler_client/src/ui/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeNotifier>(create: (context) => StateProvider()),
      ],
      child: ScreenUtilInit(
        builder: (BuildContext context, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: FlexThemeData.light(scheme: FlexScheme.sanJuanBlue, appBarElevation: 2),
            darkTheme: FlexThemeData.dark(scheme: FlexScheme.sanJuanBlue, appBarElevation: 2),
            themeMode: ThemeMode.system,
            home: Home(),
          );
        },
      ),
    );
  }
}
