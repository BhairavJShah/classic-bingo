import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Room: ${state.roomCode}'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: state.resetGame,
          child: const Text('Leave', style: TextStyle(color: CupertinoColors.systemRed)),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'WAITING FOR PLAYERS',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CupertinoListSection.insetGrouped(
                children: state.players
                    .map((p) => CupertinoListTile(
                          leading: const Icon(CupertinoIcons.person_fill),
                          title: Text(p.name),
                        ))
                    .toList(),
              ),
            ),
            if (state.players.isNotEmpty && state.players[0].id == state.myId)
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: state.players.length >= 2 ? state.startOnlineGame : null,
                    child: const Text('START GAME'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
