import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';
import '../widgets/apple_card.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  List<int?> board = List.filled(25, null);

  void _onPress(int i) {
    setState(() {
      if (board[i] != null) {
        board[i] = null;
      } else {
        Set<int> used = board.whereType<int>().toSet();
        for (int n = 1; n <= 25; n++) {
          if (!used.contains(n)) {
            board[i] = n;
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Grid Design'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text('Begin'),
          onPressed: () {
            if (board.contains(null)) {
              showCupertinoDialog(
                context: context,
                builder: (c) => CupertinoAlertDialog(
                  title: const Text('Fill Grid'),
                  content: const Text('Please fill all 25 squares.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.pop(c),
                    )
                  ],
                ),
              );
            } else {
              state.updateBoard(board);
            }
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'FILL YOUR GRID',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 2, color: CupertinoColors.systemGrey),
            ),
            const SizedBox(height: 20),
            AppleCard(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 25,
                itemBuilder: (c, i) => GestureDetector(
                  onTap: () => _onPress(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: board[i] != null ? CupertinoColors.activeBlue : CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${board[i] ?? ""}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: CupertinoColors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CupertinoButton(
              onPressed: () => setState(() => board = List.generate(25, (i) => i + 1)..shuffle()),
              child: const Text('Auto-Fill'),
            ),
            CupertinoButton(
              onPressed: () => setState(() => board = List.filled(25, null)),
              child: const Text('Clear', style: TextStyle(color: CupertinoColors.destructiveRed)),
            ),
          ],
        ),
      ),
    );
  }
}
