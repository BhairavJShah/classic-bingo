import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/player_data.dart';
import '../widgets/apple_card.dart';
import '../widgets/bingo_line_painter.dart';

class PlayingScreen extends StatelessWidget {
  const PlayingScreen({super.key});

  void _confirmQuit(BuildContext context, GameState state) => showCupertinoDialog(
        context: context,
        builder: (c) => CupertinoAlertDialog(
          title: const Text('Quit Match?'),
          content: const Text('Your progress will be lost.'),
          actions: [
            CupertinoDialogAction(child: const Text('No'), onPressed: () => Navigator.pop(c)),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(c);
                state.resetGame();
              },
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final me = state.players.firstWhere((p) => p.id == state.myId);
    final isMyTurn = state.players[state.turnIndex % state.players.length].id == state.myId;
    final isGameOver = state.winnerId != null;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          isGameOver
              ? 'Match Finished'
              : (isMyTurn ? 'Your Turn' : 'Waiting...'),
          style: TextStyle(
            color: isGameOver
                ? CupertinoColors.systemGrey
                : (isMyTurn ? CupertinoColors.activeBlue : CupertinoColors.systemGrey),
          ),
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => _confirmQuit(context, state),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                _appleBingoIndicator(me.lines),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 25,
                          itemBuilder: (c, i) => GestureDetector(
                            onTap: (isMyTurn && !isGameOver) ? () => state.broadcastMove(me.board[i]!) : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                color: me.marks[i] ? CupertinoColors.systemGrey6 : CupertinoColors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: me.marks[i] ? [] : [BoxShadow(color: CupertinoColors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Text(
                                      '${me.board[i]}',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        color: me.marks[i] ? CupertinoColors.systemGrey3 : CupertinoColors.black,
                                      ),
                                    ),
                                  ),
                                  if (me.marks[i])
                                    const Center(
                                      child: Opacity(
                                        opacity: 0.4,
                                        child: Icon(CupertinoIcons.xmark, color: CupertinoColors.systemRed, size: 40),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        IgnorePointer(child: CustomPaint(size: Size.infinite, painter: BingoLinePainter(me.marks))),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${me.lines} LINES COMPLETED',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: CupertinoColors.systemGrey, letterSpacing: 1.5),
                ),
                const SizedBox(height: 40),
              ],
            ),
            
            // --- Premium Victory Overlay ---
            if (isGameOver)
              Positioned.fill(
                child: Container(
                  color: CupertinoColors.black.withOpacity(0.4),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: AppleCard(
                        padding: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: CupertinoColors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    state.winnerId == state.myId ? CupertinoIcons.sparkles : CupertinoIcons.flag_fill,
                                    size: 60,
                                    color: state.winnerId == state.myId ? CupertinoColors.systemYellow : CupertinoColors.systemRed,
                                  ),
                                  Text(
                                    state.winnerId == state.myId ? 'Victory!' : 'Game Over',
                                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    state.winnerId == state.myId ? 'You reached 5 lines first.' : 'The Bot reached 5 lines first.',
                                    style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            Container(height: 1, color: CupertinoColors.separator),
                            Container(
                              height: 250,
                              color: Color(0xFFF2F2F7),
                              child: ListView(
                                padding: const EdgeInsets.all(15),
                                children: [
                                  const Text('VERIFY BOARDS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: CupertinoColors.systemGrey, letterSpacing: 1.2)),
                                  const SizedBox(height: 10),
                                  ...state.players.map((p) => _verificationRow(p)).toList(),
                                ],
                              ),
                            ),
                            Container(height: 1, color: CupertinoColors.separator),
                            CupertinoButton(
                              onPressed: state.resetGame,
                              child: const Text('Back to Menu', style: TextStyle(fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _verificationRow(PlayerData p) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(12)),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${p.lines} Lines completed', style: TextStyle(fontSize: 12, color: p.lines >= 5 ? CupertinoColors.activeGreen : CupertinoColors.systemGrey)),
            ],
          ),
        ),
        // Mini Board preview
        SizedBox(
          width: 60, height: 60,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, crossAxisSpacing: 1, mainAxisSpacing: 1),
            itemCount: 25,
            itemBuilder: (c, i) => Container(color: p.marks[i] ? CupertinoColors.systemRed : CupertinoColors.systemGrey5),
          ),
        ),
      ],
    ),
  );

  Widget _appleBingoIndicator(int lines) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            5,
            (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: i < lines ? CupertinoColors.activeOrange : CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: i < lines ? CupertinoColors.activeOrange : CupertinoColors.systemGrey5, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      ['B', 'I', 'N', 'G', 'O'][i],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: i < lines ? CupertinoColors.white : CupertinoColors.systemGrey4,
                      ),
                    ),
                  ),
                )),
      );
}
