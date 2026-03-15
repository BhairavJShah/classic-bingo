import 'package:flutter/cupertino.dart';

class BingoLinePainter extends CustomPainter {
  final List<bool> marks;
  BingoLinePainter(this.marks);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.systemRed.withOpacity(0.6)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    double step = size.width / 5;

    for (int i = 0; i < 5; i++) {
      // Rows
      if (Iterable.generate(5, (j) => marks[i * 5 + j]).every((m) => m)) {
        canvas.drawLine(Offset(10, i * step + step / 2), Offset(size.width - 10, i * step + step / 2), paint);
      }
      // Columns
      if (Iterable.generate(5, (j) => marks[i + j * 5]).every((m) => m)) {
        canvas.drawLine(Offset(i * step + step / 2, 10), Offset(i * step + step / 2, size.height - 10), paint);
      }
    }
    // Diagonals
    if (Iterable.generate(5, (i) => marks[i * 6]).every((m) => m)) {
      canvas.drawLine(const Offset(10, 10), Offset(size.width - 10, size.height - 10), paint);
    }
    if (Iterable.generate(5, (i) => marks[(i + 1) * 4]).every((m) => m)) {
      canvas.drawLine(Offset(size.width - 10, 10), Offset(10, size.height - 10), paint);
    }
  }

  @override
  bool shouldRepaint(BingoLinePainter old) => true;
}
