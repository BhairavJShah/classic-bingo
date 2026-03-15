import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context, listen: false);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Join Match'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => state.setScreen(Screen.onlineMenu),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'ENTER ROOM CODE',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: CupertinoColors.systemGrey, letterSpacing: 1.5),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _controller,
                placeholder: 'ABCDE',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 8),
                maxLength: 5,
                autofocus: true,
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: CupertinoColors.systemGrey4),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  borderRadius: BorderRadius.circular(16),
                  onPressed: () => state.joinRoom(_controller.text.toUpperCase()),
                  child: const Text('JOIN LOBBY', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
