import 'package:flutter/cupertino.dart';

class AppleCard extends StatelessWidget {
  final Widget child;
  final double padding;
  final Color? color;

  const AppleCard({super.key, required this.child, this.padding = 15, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: color ?? CupertinoColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: child,
    );
  }
}
