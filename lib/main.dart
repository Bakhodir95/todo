import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/utils/app_consts.dart';
import 'package:todo/views/screens/admin_panel_page.dart';
import 'package:todo/views/screens/home_page.dart';
import 'package:todo/views/screens/login_vs_register/login_page.dart';
import 'package:todo/views/screens/maneger_page.dart';
import 'package:todo/views/screens/note_page.dart';
import 'package:todo/views/screens/settings_page.dart';
import 'package:todo/views/screens/todo_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  bool isToken = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      bool? themabool = sharedPreference.getBool('themeMode');

      if (themabool == null || themabool == false) {
        AppConsts.themeMode = ThemeMode.light;
      } else {
        AppConsts.themeMode = ThemeMode.dark;
      }
      AppConsts.token = sharedPreference.getString("token");
      AppConsts.localId = sharedPreference.getString("localId");
      String? dateTimes = sharedPreference.getString("tokenTime");
      if (sharedPreference.getString("lenguage") != null) {
        AppConsts.lenguage = sharedPreference.getString("lenguage")!;
      }
      if (dateTimes != null) {
        DateTime time = DateTime.parse(dateTimes);
        isToken = DateTime.now().isBefore(time);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      _savePreferences();
    }
  }

  Future<void> _savePreferences() async {
    final sharedPreference = await SharedPreferences.getInstance();
    bool theme = AppConsts.themeMode == ThemeMode.dark ? true : false;
    await sharedPreference.setBool("themeMode", theme);
    await sharedPreference.setString("lenguage", AppConsts.lenguage);
  }

  void toggleThemeMode() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale(AppConsts.lenguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: AppConsts.themeMode,
      debugShowCheckedModeBanner: false,
      routes: {
        '/todo': (context) => const TodoPage(),
        '/note': (context) => const NotePage(),
        '/home': (context) => HomePage(
              mainSetState: () {
                setState(() {});
              },
            ),
        '/settings': (context) => SettingsPage(
              setMain: toggleThemeMode,
            ),
        '/admin': (context) => AdminPanelPage(
              mainSetState: toggleThemeMode,
            ),
      },
      home: isToken
          ? ManagerPage(
              mainSetState: () {
                setState(() {});
              },
            )
          : LoginScreen(
              mainSetState: () {
                setState(() {});
              },
            ),
    );
  }
}
