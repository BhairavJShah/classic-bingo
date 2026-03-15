class PlayerData {
  String id;
  String name;
  List<int?> board;
  List<bool> marks;
  int lines;

  PlayerData({
    required this.id,
    required this.name,
    required this.board,
    required this.marks,
    this.lines = 0,
  });
}
