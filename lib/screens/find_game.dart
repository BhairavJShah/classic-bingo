import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/enums.dart';

class FindGameScreen extends StatefulWidget {
  const FindGameScreen({super.key});

  @override
  State<FindGameScreen> createState() => _FindGameScreenState();
}

class _FindGameScreenState extends State<FindGameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameState>(context, listen: false).listenToPublicRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Public Matches'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => state.setScreen(Screen.onlineMenu),
        ),
      ),
      child: SafeArea(
        child: state.publicRooms.isEmpty
            ? const Center(
                child: Text('Searching for games...', style: TextStyle(color: CupertinoColors.systemGrey)),
              )
            : CupertinoListSection.insetGrouped(
                header: const Text('AVAILABLE ROOMS'),
                children: state.publicRooms.map((room) => CupertinoListTile.notched(
                  leading: const Icon(CupertinoIcons.globe, color: CupertinoColors.activeBlue),
                  title: Text("${room['hostName']}'s Match"),
                  subtitle: Text("Code: ${room['code']}"),
                  trailing: Row(
                    children: [
                      Text("${room['playerCount']}/${room['maxPlayers']}", style: const TextStyle(color: CupertinoColors.systemGrey)),
                      const SizedBox(width: 5),
                      const Icon(CupertinoIcons.chevron_forward, size: 14, color: CupertinoColors.systemGrey4),
                    ],
                  ),
                  onTap: () => state.joinRoom(room['code']),
                )).toList(),
              ),
      ),
    );
  }
}
