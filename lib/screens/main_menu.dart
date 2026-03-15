import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context, listen: false);
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: CupertinoColors.systemPink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Bingo',
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -3,
                      color: CupertinoColors.black,
                    ),
                  ),
                  const Text(
                    'PREMIUM',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 6,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 100),
                  _actionBtn(
                    'Offline Play',
                    CupertinoIcons.gamecontroller_fill,
                    () => state.setScreen(Screen.offlineMenu),
                  ),
                  _actionBtn(
                    'Online Play',
                    CupertinoIcons.globe,
                    () => state.setScreen(Screen.onlineMenu),
                  ),
                  _actionBtn(
                    'Settings',
                    CupertinoIcons.settings,
                    () => state.setScreen(Screen.settings),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionBtn(String t, IconData i, VoidCallback p) => Container(
        width: 280,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: CupertinoButton(
          color: CupertinoColors.white,
          borderRadius: BorderRadius.circular(22),
          onPressed: p,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(i, color: CupertinoColors.activeBlue),
              const SizedBox(width: 12),
              Text(
                t,
                style: const TextStyle(
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          ),
        ),
      );
}
