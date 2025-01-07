// import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsHelper {
  const AnalyticsHelper._();

  static Future<void> initialize() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
  }

  static Future<void> logEvent(String name, Map<String, Object> parameters) async {
    // return FirebaseAnalytics.instance.logEvent(
    //   name: name,
    //   parameters: parameters,
    // ).catchError((_) {
    //
    // });
  }

  static Future<void> logMinesweeperWin(String minesweeperSeed, int useTime) {
    return logEvent('minesweeper_win', {
      'seed': minesweeperSeed,
      'time_seconds': useTime,
    });
  }

  static Future<void> logMinesweeperLose(String minesweeperSeed, int useTime) {
    return logEvent('minesweeper_lose', {
      'seed': minesweeperSeed,
      'time_seconds': useTime,
    });
  }

  static Future<void> logSolitaireWin(String solitaireSeed) {
    return logEvent('solitaire_win', {
      'seed': solitaireSeed,
    });
  }

  static Future<void> logApplicationOpen(String applicationName) {
    return logEvent('open_application', {
      'application_name': applicationName,
    });
  }
}