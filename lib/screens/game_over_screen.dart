import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/player_data.dart';
import '../widgets/apple_card.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    bool iWon = state.winnerId == state.myId;
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(25),
          children: [
            const SizedBox(height: 20),
            Center(
              child: Icon(
                iWon ? CupertinoIcons.sparkles : CupertinoIcons.flag_fill,
                size: 80,
                color: iWon ? CupertinoColors.systemYellow : CupertinoColors.systemRed,
              ),
            ),
            Center(
              child: Text(
                iWon ? 'Champion!' : 'Better Luck Next Time',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(height: 40),
            ...state.players.map((p) => _appleVerifyCard(p)).toList(),
            const SizedBox(height: 30),
            CupertinoButton.filled(
              onPressed: state.resetGame,
              child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appleVerifyCard(PlayerData p) => AppleCard(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(p.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('${p.lines} Lines', style: TextStyle(color: p.lines >= 5 ? CupertinoColors.activeGreen : CupertinoColors.systemGrey)),
              ],
            ),
            const SizedBox(height: 15),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 25,
              itemBuilder: (c, i) => Container(
                height: 30,
                decoration: BoxDecoration(
                  color: p.marks[i] ? CupertinoColors.systemGrey6 : CupertinoColors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: CupertinoColors.systemGrey5),
                ),
                child: Center(
                  child: Text(
                    '${p.board[i]}',
                    style: TextStyle(
                      fontSize: 12,
                      color: p.marks[i] ? CupertinoColors.activeBlue : CupertinoColors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
