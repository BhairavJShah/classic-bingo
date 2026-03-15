import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';
import '../widgets/premium_card.dart';

class OfflineMenu extends StatelessWidget {
  const OfflineMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Game Mode'),
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => state.setScreen(Screen.menu),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            PremiumCard(
              title: 'Play with Bot',
              subtitle: 'Sophisticated AI match',
              icon: CupertinoIcons.device_phone_portrait,
              color: CupertinoColors.systemIndigo,
              onTap: () => state.startOfflineGame(GameMode.vsBot),
            ),
            PremiumCard(
              title: 'Solo Practice',
              subtitle: 'Master your grid',
              icon: CupertinoIcons.person_crop_circle_fill,
              color: CupertinoColors.systemGreen,
              onTap: () => state.startOfflineGame(GameMode.solo),
            ),
          ],
        ),
      ),
    );
  }
}
