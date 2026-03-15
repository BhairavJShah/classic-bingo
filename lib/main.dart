import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'state/game_state.dart';
import 'models/enums.dart';
import 'screens/main_menu.dart';
import 'screens/offline_menu.dart';
import 'screens/online_menu.dart';
import 'screens/host_settings.dart';
import 'screens/join_room.dart';
import 'screens/find_game.dart';
import 'screens/lobby_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/playing_screen.dart';
import 'screens/game_over_screen.dart';
import 'screens/settings_screen.dart';

// --- Firebase Configuration ---
const firebaseOptions = FirebaseOptions(
  apiKey: "AIzaSyBgGgIBXtVGYISBPnO8fOYvMfw2VtF3wcA",
  appId: "1:18447923888:android:ad3488aa3d479a33a29975",
  messagingSenderId: "18447923888",
  projectId: "classic-kid-bingo",
  databaseURL: "https://classic-kid-bingo-default-rtdb.firebaseio.com",
  storageBucket: "classic-kid-bingo.firebasestorage.app",
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: firebaseOptions);
  } catch (e) {
    debugPrint("Firebase init failed: $e");
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const BingoApp(),
    ),
  );
}

class BingoApp extends StatelessWidget {
  const BingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Bingo',
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        primaryColor: CupertinoColors.activeBlue,
        scaffoldBackgroundColor: Color(0xFFF2F2F7),
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: '.SF Pro Text', color: CupertinoColors.label),
        ),
      ),
      home: BingoAppContent(),
    );
  }
}

class BingoAppContent extends StatelessWidget {
  const BingoAppContent({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _getScreen(state.currentScreen),
    );
  }

  Widget _getScreen(Screen screen) {
    switch (screen) {
      case Screen.menu: return const MainMenu();
      case Screen.offlineMenu: return const OfflineMenu();
      case Screen.onlineMenu: return const OnlineMenu();
      case Screen.hostSettings: return const HostSettingsScreen();
      case Screen.joinRoom: return const JoinRoomScreen();
      case Screen.findGame: return const FindGameScreen();
      case Screen.lobby: return const LobbyScreen();
      case Screen.setup: return const SetupScreen();
      case Screen.playing: return const PlayingScreen();
      case Screen.gameOver: return const GameOverScreen();
      case Screen.settings: return const SettingsScreen();
      default: return const MainMenu();
    }
  }
}
