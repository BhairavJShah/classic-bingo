import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';

class HostSettingsScreen extends StatelessWidget {
  const HostSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Game Settings'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => state.setScreen(Screen.onlineMenu),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CupertinoListSection.insetGrouped(
              header: const Text('ROOM CONFIGURATION'),
              children: [
                CupertinoListTile.notched(
                  title: const Text('Max Players'),
                  trailing: Row(
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => state.maxPlayers = max(2, state.maxPlayers - 1),
                        child: const Icon(CupertinoIcons.minus_circle),
                      ),
                      Text('  ${state.maxPlayers}  ', style: const TextStyle(fontWeight: FontWeight.bold)),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => state.maxPlayers = min(5, state.maxPlayers + 1),
                        child: const Icon(CupertinoIcons.plus_circle),
                      ),
                    ],
                  ),
                ),
                CupertinoListTile.notched(
                  title: const Text('Private Room'),
                  subtitle: const Text('Only players with code can join'),
                  trailing: CupertinoSwitch(
                    value: state.isPrivate,
                    onChanged: (v) => state.isPrivate = v,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(16),
                  onPressed: state.createRoom,
                  child: const Text('CREATE LOBBY', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  int max(int a, int b) => a > b ? a : b;
  int min(int a, int b) => a < b ? a : b;
}
