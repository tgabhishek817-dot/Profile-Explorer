import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final bool liked;
  final VoidCallback onTap;
  const LikeButton({Key? key, required this.liked, required this.onTap}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    if (widget.liked) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.liked != widget.liked) {
      if (widget.liked) _controller.forward();
      else _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 1.15)
            .animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value;
            return Icon(
              t > 0.5 ? Icons.favorite : Icons.favorite_border,
              color: t > 0.5 ? Colors.redAccent : Colors.black54,
            );
          },
        ),
      ),
    );
  }
}
