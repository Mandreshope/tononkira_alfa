import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tononkira_alfa/bloc/authBloc.dart';
import 'package:tononkira_alfa/bloc/lyricsBloc.dart';
import 'package:tononkira_alfa/models/lyrics.dart';
import 'package:tononkira_alfa/pages/home.dart';
import 'package:tononkira_alfa/tools/routeSettings.dart';
import 'package:flutter/services.dart';
import 'package:tononkira_alfa/bloc/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  // Register Adapter
  Hive.registerAdapter(LyricsModelAdapter());

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LyricsBloc>(create: (_) => LyricsBloc()),
        ChangeNotifierProvider<AuthBloc>(create: (_) => AuthBloc()),
        ChangeNotifierProvider<SettingsBloc>(create: (_) => SettingsBloc()),
      ],
      child: MaterialApp(
        title: 'Tononkira ALFA',
        theme: ThemeData(
          primarySwatch: MaterialColor(
            0xFFFFD3BE,
            <int, Color>{
              50: Color(0xFFFFFAF7),
              100: Color(0xFFFFF2EC),
              200: Color(0xFFFFE9DF),
              300: Color(0xFFFFE0D2),
              400: Color(0xFFFFDAC8),
              500: Color(0xFFFFD3BE),
              600: Color(0xFFFFCEB8),
              700: Color(0xFFFFC8AF),
              800: Color(0xFFFFC2A7),
              900: Color(0xFFFFB799),
            },
          ),
        ),
        home: HomePage(),
        onGenerateRoute: (settings) => routeSettings(settings),
      ),
    );
  }
}