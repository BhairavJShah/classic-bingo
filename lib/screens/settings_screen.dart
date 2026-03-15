import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => state.setScreen(Screen.menu),
          child: const Icon(CupertinoIcons.back),
        ),
      ),
      child: SafeArea(
        child: CupertinoListSection.insetGrouped(
          children: [
            CupertinoListTile.notched(
              title: const Text('Music'),
              leading: const Icon(CupertinoIcons.music_note_2, color: CupertinoColors.activeBlue),
              trailing: CupertinoSwitch(
                value: state.isMusicEnabled,
                onChanged: (v) => state.isMusicEnabled = v,
              ),
            ),
            CupertinoListTile.notched(
              title: const Text('Sound Effects'),
              leading: const Icon(CupertinoIcons.speaker_2_fill, color: CupertinoColors.systemOrange),
              trailing: CupertinoSwitch(
                value: state.isSoundEnabled,
                onChanged: (v) => state.isSoundEnabled = v,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
