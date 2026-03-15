import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';
import '../widgets/premium_card.dart';

class OnlineMenu extends StatelessWidget {
  const OnlineMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Multiplayer'), border: null,
        leading: CupertinoButton(padding: EdgeInsets.zero, child: const Icon(CupertinoIcons.back), onPressed: () => state.setScreen(Screen.menu)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            PremiumCard(
              title: 'Host a Game',
              subtitle: 'Start a private lobby',
              icon: CupertinoIcons.add_circled,
              color: CupertinoColors.activeBlue,
              onTap: () => state.setScreen(Screen.hostSettings),
            ),
            PremiumCard(
              title: 'Join Room',
              subtitle: 'Enter a room code',
              icon: CupertinoIcons.number_square_fill,
              color: CupertinoColors.systemOrange,
              onTap: () => state.setScreen(Screen.joinRoom),
            ),
            PremiumCard(
              title: 'Find Game',
              subtitle: 'Browse public matches',
              icon: CupertinoIcons.globe,
              color: CupertinoColors.systemGreen,
              onTap: () => state.setScreen(Screen.findGame),
            ),
          ],
        ),
      ),
    );
  }
}
