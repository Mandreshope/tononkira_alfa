import 'package:tononkira_alfa/pages/home.dart';
import 'package:tononkira_alfa/pages/lyrics/lyrics.dart';
import 'package:tononkira_alfa/pages/lyrics/lyricsDetail.dart';
import 'package:tononkira_alfa/tools/constant.dart';
import 'package:tononkira_alfa/tools/routeTransition.dart';
import 'package:tononkira_alfa/pages/favoris.dart';
import 'package:tononkira_alfa/pages/about.dart';
import 'package:tononkira_alfa/pages/settings.dart';

routeSettings(settings) {
  switch (settings.name) {
    case HOME_PAGE:
      return CustomOffsetRoute(
        builder: (_) => HomePage(),
        settings: settings,
      );
    case FAVORIS_PAGE:
      return CustomOffsetRoute(
        builder: (_) => FavorisPage(),
        settings: settings,
      );
    case SETTINGS_PAGE:
      return CustomOffsetRoute(
        builder: (_) => SettingsPage(),
        settings: settings,
      );
    case ABOUT_PAGE:
      return CustomOffsetRoute(
        builder: (_) => AboutPage(),
        settings: settings,
      );
    case LYRICS_PAGE:
      return CustomOffsetRoute(
        builder: (_) => LyricsPage(),
        settings: settings,
      );
    case LYRICS_DETAIL_PAGE:
      return CustomOffsetRoute(
        builder: (_) => LyricsDetailPage(),
        settings: settings,
      );
  }

  return CustomOffsetRoute(
    builder: (_) => HomePage(),
    settings: settings,
  );
}
