import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final Color color;
  final String label;
  final String? centerText;
  final double strokeWidth;

  const CustomCircularProgressIndicator({
    super.key,
    required this.value,
    this.size = 100,
    required this.color,
    required this.label,
    this.centerText,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: size,
          width: size,
          child: Stack(
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: strokeWidth,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  centerText ?? '${(value * 100).toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AnimatedCircularProgress extends StatefulWidget {
  final double value;
  final double size;
  final Color color;
  final String label;
  final String? centerText;
  final Duration animationDuration;

  const AnimatedCircularProgress({
    super.key,
    required this.value,
    this.size = 100,
    required this.color,
    required this.label,
    this.centerText,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedCircularProgress> createState() => _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomCircularProgressIndicator(
          value: _animation.value,
          size: widget.size,
          color: widget.color,
          label: widget.label,
          centerText: widget.centerText,
        );
      },
    );
  }
}