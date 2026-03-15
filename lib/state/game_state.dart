import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/player_data.dart';
import '../models/enums.dart';

class GameState extends ChangeNotifier {
  Screen currentScreen = Screen.menu;
  GameMode? gameMode;
  String myId = Random().nextInt(1000000).toString();
  String? roomCode;
  List<PlayerData> players = [];
  List<int> calledNumbers = [];
  List<int?> setupBoard = List.filled(25, null);
  int turnIndex = 0;
  String? winnerId;
  
  // Settings
  bool isMusicEnabled = true;
  bool isSoundEnabled = true;

  // Online Room Settings
  int _maxPlayers = 2;
  int get maxPlayers => _maxPlayers;
  set maxPlayers(int value) {
    _maxPlayers = value;
    notifyListeners();
  }

  int _bestOf = 3;
  int get bestOf => _bestOf;
  set bestOf(int value) {
    _bestOf = value;
    notifyListeners();
  }

  bool _isPrivate = true;
  bool get isPrivate => _isPrivate;
  set isPrivate(bool value) {
    _isPrivate = value;
    notifyListeners();
  }
  List<Map<String, dynamic>> publicRooms = [];

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  StreamSubscription? roomSubscription;
  StreamSubscription? publicRoomsSubscription;

  void setScreen(Screen screen) {
    currentScreen = screen;
    notifyListeners();
  }

  void resetGame() {
    _botTimer?.cancel();
    roomSubscription?.cancel();
    publicRoomsSubscription?.cancel();
    currentScreen = Screen.menu;
    gameMode = null;
    players = [];
    calledNumbers = [];
    setupBoard = List.filled(25, null);
    turnIndex = 0;
    winnerId = null;
    roomCode = null;
    notifyListeners();
  }

  // --- Offline Logic ---

  void startOfflineGame(GameMode mode) {
    gameMode = mode;
    players = [
      PlayerData(id: myId, name: 'You', board: List.filled(25, null), marks: List.filled(25, false)),
    ];
    if (mode == GameMode.vsBot) {
      players.add(PlayerData(
        id: 'bot',
        name: 'Bot',
        board: List.generate(25, (i) => i + 1)..shuffle(),
        marks: List.filled(25, false),
      ));
    }
    setScreen(Screen.setup);
  }

  // --- Online Logic ---

  void createRoom() async {
    String code = List.generate(5, (_) => String.fromCharCode(Random().nextInt(26) + 65)).join();
    roomCode = code;
    gameMode = GameMode.online;

    await _dbRef.child('rooms/$code').set({
      'hostId': myId,
      'status': 'LOBBY',
      'settings': {
        'maxPlayers': maxPlayers,
        'bestOf': bestOf,
        'isPrivate': isPrivate,
      },
      'players': {myId: {'name': 'Host', 'id': myId}},
      'turnIndex': 0,
      'createdAt': ServerValue.timestamp,
    });

    listenToRoom(code);
    setScreen(Screen.lobby);
  }

  void joinRoom(String code) async {
    if (code.isEmpty) return;
    DataSnapshot snapshot = await _dbRef.child('rooms/$code').get();
    if (!snapshot.exists) return;

    Map room = snapshot.value as Map;
    Map playersMap = room['players'] as Map;
    int pCount = playersMap.length;
    int maxP = room['settings']['maxPlayers'] ?? 2;

    if (pCount >= maxP) return;

    await _dbRef.child('rooms/$code/players/$myId').set({
      'name': 'Player ${pCount + 1}',
      'id': myId,
    });

    roomCode = code;
    gameMode = GameMode.online;
    listenToRoom(code);
    setScreen(Screen.lobby);
  }

  void listenToPublicRooms() {
    publicRoomsSubscription?.cancel();
    publicRoomsSubscription = _dbRef.child('rooms').onValue.listen((event) {
      if (event.snapshot.value == null) {
        publicRooms = [];
        notifyListeners();
        return;
      }
      
      Map allRooms = event.snapshot.value as Map;
      List<Map<String, dynamic>> tempRooms = [];
      
      allRooms.forEach((code, data) {
        if (data['settings'] != null && 
            data['settings']['isPrivate'] == false && 
            data['status'] == 'LOBBY') {
          
          Map playersData = data['players'] as Map;
          tempRooms.add({
            'code': code,
            'hostName': playersData.values.first['name'] ?? 'Host',
            'playerCount': playersData.length,
            'maxPlayers': data['settings']['maxPlayers'],
          });
        }
      });
      
      publicRooms = tempRooms;
      notifyListeners();
    });
  }

  void listenToRoom(String code) {
    roomSubscription?.cancel();
    roomSubscription = _dbRef.child('rooms/$code').onValue.listen((event) {
      if (event.snapshot.value == null) return;
      Map room = event.snapshot.value as Map;
      
      // Update players
      Map playersMap = room['players'] as Map;
      players = playersMap.values.map((p) => PlayerData(
        id: p['id'],
        name: p['name'],
        board: p['board'] != null ? List<int?>.from(p['board']) : List.filled(25, null),
        marks: List.filled(25, false),
        lines: 0,
      )).toList();

      if (room['status'] == 'PLAYING' && currentScreen == Screen.lobby) setScreen(Screen.setup);
      
      calledNumbers = room['moves'] != null ? (room['moves'] as Map).values.cast<int>().toList() : [];
      syncMarks();
      turnIndex = room['turnIndex'] ?? 0;
      notifyListeners();
    });
  }

  void startOnlineGame() async {
    await _dbRef.child('rooms/$roomCode').update({'status': 'PLAYING'});
  }

  void broadcastMove(int num) async {
    if (calledNumbers.contains(num)) return;
    if (gameMode == GameMode.online) {
      await _dbRef.child('rooms/$roomCode/moves').push().set(num);
      await _dbRef.child('rooms/$roomCode').update({'turnIndex': turnIndex + 1});
    } else {
      calledNumbers.add(num);
      syncMarks();
      turnIndex++;
      notifyListeners();
    }
  }

  void updateBoard(List<int?> board) async {
    if (gameMode == GameMode.online) {
      await _dbRef.child('rooms/$roomCode/players/$myId').update({'board': board});
    } else {
      players.firstWhere((p) => p.id == myId).board = board;
    }
    setScreen(Screen.playing);
  }

  void syncMarks() {
    bool someoneWon = false;
    String? currentWinner;
    for (var p in players) {
      p.marks = List.filled(25, false);
      if (p.board.isNotEmpty && p.board.length == 25) {
        for (var num in calledNumbers) {
          int idx = p.board.indexOf(num);
          if (idx != -1) p.marks[idx] = true;
        }
      }
      p.lines = _checkLines(p.marks);
      if (p.lines >= 5) { someoneWon = true; currentWinner = p.id; }
    }
    if (someoneWon && winnerId == null && currentScreen == Screen.playing) {
      winnerId = currentWinner;
    }
  }

  int _checkLines(List<bool> marks) {
    int lines = 0;
    for (int i = 0; i < 5; i++) {
      if (Iterable.generate(5, (j) => marks[i * 5 + j]).every((m) => m)) lines++;
      if (Iterable.generate(5, (j) => marks[i + j * 5]).every((m) => m)) lines++;
    }
    if (Iterable.generate(5, (i) => marks[i * 6]).every((m) => m)) lines++;
    if (Iterable.generate(5, (i) => marks[(i + 1) * 4]).every((m) => m)) lines++;
    return min(5, lines);
  }

  Timer? _botTimer;
  void checkBotTurn() {
    if (gameMode == GameMode.vsBot && currentScreen == Screen.playing && players[turnIndex % players.length].id == 'bot' && winnerId == null) {
      _botTimer?.cancel();
      _botTimer = Timer(const Duration(milliseconds: 1500), () {
        final bot = players.firstWhere((p) => p.id == 'bot');
        final user = players.firstWhere((p) => p.id == myId);
        final available = bot.board.where((num) => num != null && !calledNumbers.contains(num)).cast<int>().toList();
        if (available.isNotEmpty) {
          int bestMove = available[0];
          double maxScore = -999999;
          for (int num in available) {
            double score = _calculateHeuristic(bot, num) - (_calculateHeuristic(user, num) * 0.8);
            if (score > maxScore) { maxScore = score; bestMove = num; }
          }
          broadcastMove(bestMove);
        }
      });
    }
  }

  double _calculateHeuristic(PlayerData p, int num) {
    int idx = p.board.indexOf(num);
    if (idx == -1) return 0;
    double score = 0;
    int r = idx ~/ 5, c = idx % 5;
    score += pow(5.0, _countInPath(p, List.generate(5, (i) => r * 5 + i))).toDouble();
    score += pow(5.0, _countInPath(p, List.generate(5, (i) => i * 5 + c))).toDouble();
    return score;
  }

  int _countInPath(PlayerData p, List<int> ids) {
    int cnt = 0;
    for (int i in ids) if (p.marks[i]) cnt++;
    return cnt;
  }

  @override
  void notifyListeners() { super.notifyListeners(); checkBotTurn(); }
}
