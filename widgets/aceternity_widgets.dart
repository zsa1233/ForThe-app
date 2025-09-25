import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

/// A collection of Aceternity UI-inspired widgets
/// These provide a modern, animated UI experience while still working with Material Design

/// Glassmorphic card with subtle blur effect
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.color,
    this.borderRadius,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? AppTheme.borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppTheme.borderRadius,
          child: Container(
            width: width,
            height: height,
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withOpacity(0.15),
              borderRadius: borderRadius ?? AppTheme.borderRadius,
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient-bordered card with hover effects
class GradientBorderCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;
  final Gradient gradient;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const GradientBorderCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.width,
    this.height,
    this.gradient = AppTheme.primaryGradient,
    this.borderRadius,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<GradientBorderCard> createState() => _GradientBorderCardState();
}

class _GradientBorderCardState extends State<GradientBorderCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.backgroundColor ?? 
      (isDarkMode ? AppTheme.cardColor : Colors.white);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: widget.borderRadius ?? AppTheme.borderRadius,
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: (widget.borderRadius ?? AppTheme.borderRadius)
                  .subtract(const BorderRadius.all(Radius.circular(1.5))),
            ),
            child: widget.child,
          ),
        )
        .animate(target: isHovering ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02))
        .boxShadow(
          begin: const BoxShadow(color: Colors.transparent),
          end: BoxShadow(
            color: widget.gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ),
      ),
    );
  }
}

/// Gradient text that animates on hover
class GradientText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;

  const GradientText(
    this.text, {
    super.key,
    this.style,
    this.gradient = AppTheme.primaryGradient,
    this.textAlign,
  });

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: ShaderMask(
        shaderCallback: (bounds) => widget.gradient.createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: Text(
          widget.text,
          style: widget.style?.copyWith(
            color: Colors.white,
          ) ?? 
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: widget.textAlign,
        ),
      )
      .animate(target: isHovering ? 1 : 0)
      .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05), curve: Curves.easeOut)
    );
  }
}

/// Animated pulse button with gradient
class PulseButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData? icon;
  final Gradient gradient;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const PulseButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.gradient = AppTheme.primaryGradient,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  });

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? 
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: widget.borderRadius ?? AppTheme.roundedBorderRadius,
            boxShadow: isHovering ? AppTheme.coloredShadow : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
        .animate(target: isHovering ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05))
        .then()
        .shimmer(duration: 1.seconds, color: Colors.white24),
      ),
    );
  }
}

/// Spotlight card that follows cursor
class SpotlightCard extends StatefulWidget {
  final Widget child;
  final Color? color;
  final Color spotlightColor;
  final double spotlightSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  
  const SpotlightCard({
    super.key,
    required this.child,
    this.color,
    this.spotlightColor = Colors.white,
    this.spotlightSize = 300,
    this.borderRadius,
    this.padding,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  State<SpotlightCard> createState() => _SpotlightCardState();
}

class _SpotlightCardState extends State<SpotlightCard> {
  Offset? position;

  void _updatePosition(PointerEvent details) {
    setState(() {
      position = details.localPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.color ?? 
      (isDarkMode ? AppTheme.cardColor : Colors.white);
      
    return MouseRegion(
      onEnter: (event) => _updatePosition(event),
      onHover: (event) => _updatePosition(event),
      onExit: (event) => setState(() => position = null),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.height,
          padding: widget.padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: widget.borderRadius ?? AppTheme.borderRadius,
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
            boxShadow: AppTheme.subtleShadow,
          ),
          child: Stack(
            children: [
              if (position != null)
                Positioned(
                  left: position!.dx - widget.spotlightSize / 2,
                  top: position!.dy - widget.spotlightSize / 2,
                  child: Container(
                    width: widget.spotlightSize,
                    height: widget.spotlightSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.spotlightColor.withOpacity(0.1),
                          widget.spotlightColor.withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

/// 3D-like card that tilts based on cursor position
class TiltCard extends StatefulWidget {
  final Widget child;
  final double tiltFactor;
  final BorderRadius? borderRadius;
  final Color? color;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  
  const TiltCard({
    super.key,
    required this.child,
    this.tiltFactor = 0.05,
    this.borderRadius,
    this.color,
    this.onTap,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  Offset _offset = Offset.zero;
  bool _isHovering = false;

  void _updateOffset(PointerEvent details, BoxConstraints constraints) {
    final centerX = constraints.maxWidth / 2;
    final centerY = constraints.maxHeight / 2;
    
    // Calculate offset from center (range -1 to 1)
    final dx = (details.localPosition.dx - centerX) / centerX;
    final dy = (details.localPosition.dy - centerY) / centerY;
    
    setState(() {
      _offset = Offset(dx, dy);
      _isHovering = true;
    });
  }

  void _resetOffset() {
    setState(() {
      _offset = Offset.zero;
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bgColor = widget.color ?? 
      (isDarkMode ? AppTheme.cardColor : Colors.white);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate rotation angles based on offset
        final rotateX = -_offset.dy * widget.tiltFactor;
        final rotateY = _offset.dx * widget.tiltFactor;

        return MouseRegion(
          onEnter: (event) => _updateOffset(event, constraints),
          onHover: (event) => _updateOffset(event, constraints),
          onExit: (_) => _resetOffset(),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: widget.width,
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: widget.borderRadius ?? AppTheme.borderRadius,
                boxShadow: _isHovering ? AppTheme.sharpShadow : AppTheme.subtleShadow,
              ),
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(rotateX)
                ..rotateY(rotateY),
              transformAlignment: Alignment.center,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}