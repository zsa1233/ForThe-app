import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Stunning hotspot overlay
class TrashHeatMapOverlay extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onToggle;
  
  const TrashHeatMapOverlay({
    Key? key,
    this.isVisible = true,
    this.onToggle,
  }) : super(key: key);

  @override
  State<TrashHeatMapOverlay> createState() => _TrashHeatMapOverlayState();
}

class _TrashHeatMapOverlayState extends State<TrashHeatMapOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    return Stack(
      children: [
        // Hotspot 1 - Critical
        Positioned(
          top: 200,
          left: 180,
          child: _buildHotspot(0.9, Colors.red, 'CRITICAL'),
        ),
        
        // Hotspot 2 - High
        Positioned(
          top: 150,
          left: 160,
          child: _buildHotspot(0.6, Colors.orange, 'HIGH'),
        ),
        
        // Hotspot 3 - Medium
        Positioned(
          top: 280,
          left: 200,
          child: _buildHotspot(0.4, Colors.yellow, 'MEDIUM'),
        ),
        
        // Hotspot 4 - Low
        Positioned(
          top: 320,
          left: 140,
          child: _buildHotspot(0.2, Colors.green, 'LOW'),
        ),
        
        // Legend
        Positioned(
          bottom: 150,
          left: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 Trash Hotspots',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ).animate().shimmer(duration: 2.seconds),
                SizedBox(height: 8),
                _legendItem(Colors.red, 'Critical'),
                _legendItem(Colors.orange, 'High'),
                _legendItem(Colors.yellow, 'Medium'),
                _legendItem(Colors.green, 'Low'),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms),
        ),
      ],
    );
  }

  Widget _buildHotspot(double intensity, Color color, String level) {
    final size = 40.0 + (intensity * 30);
    
    return GestureDetector(
      onTap: () => _showDialog(intensity, level),
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 1.0 + (_pulseController.value * 0.3);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color, color.withOpacity(0.5), Colors.transparent],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${(intensity * 100).round()}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ).animate().shimmer(duration: 1.5.seconds),
          );
        },
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showDialog(double intensity, String level) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: Text(
          '🔥 $level Hotspot',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Trash Intensity: ${(intensity * 100).round()}%\n\nThis area needs cleanup attention!',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '🧹 START CLEANUP',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
