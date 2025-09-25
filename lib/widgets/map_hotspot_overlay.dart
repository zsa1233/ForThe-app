import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHotspotOverlay extends StatefulWidget {
  final GoogleMapController? controller;
  final bool isVisible;

  const MapHotspotOverlay({
    Key? key,
    required this.controller,
    required this.isVisible,
  }) : super(key: key);

  @override
  State<MapHotspotOverlay> createState() => _MapHotspotOverlayState();
}

class _MapHotspotOverlayState extends State<MapHotspotOverlay> {

  // St. Louis hotspot locations
  static const List<HotspotData> _hotspots = [
    HotspotData(
      position: LatLng(38.6488, -90.3050), // Forest Park
      intensity: 0.9,
      color: Colors.red,
      level: 'CRITICAL',
      name: 'Forest Park',
      estimatedPounds: 450,
    ),
    HotspotData(
      position: LatLng(38.6270, -90.1994), // Downtown St. Louis
      intensity: 0.7,
      color: Colors.orange,
      level: 'HIGH',
      name: 'Downtown St. Louis',
      estimatedPounds: 280,
    ),
    HotspotData(
      position: LatLng(38.6337, -90.2000), // Gateway Arch Park
      intensity: 0.5,
      color: Colors.yellow,
      level: 'MEDIUM',
      name: 'Gateway Arch Park',
      estimatedPounds: 150,
    ),
    HotspotData(
      position: LatLng(38.6117, -90.2595), // Tower Grove Park
      intensity: 0.6,
      color: Colors.orange,
      level: 'HIGH',
      name: 'Tower Grove Park',
      estimatedPounds: 200,
    ),
    HotspotData(
      position: LatLng(38.6353, -90.2846), // The Delmar Loop
      intensity: 0.4,
      color: Colors.yellow,
      level: 'MEDIUM',
      name: 'The Delmar Loop',
      estimatedPounds: 120,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || widget.controller == null) return const SizedBox.shrink();

    return FutureBuilder<List<Widget>>(
      future: _buildHotspots(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        return Stack(children: snapshot.data!);
      },
    );
  }

  Future<List<Widget>> _buildHotspots(BuildContext context) async {
    final List<Widget> widgets = [];
    
    for (final hotspot in _hotspots) {
      final screenCoordinate = await widget.controller!.getScreenCoordinate(hotspot.position);
      
      widgets.add(
        Positioned(
          left: screenCoordinate.x.toDouble() - 30,
          top: screenCoordinate.y.toDouble() - 30,
          child: _HotspotWidget(hotspot: hotspot),
        ),
      );
    }
    
    return widgets;
  }
}

class HotspotData {
  final LatLng position;
  final double intensity;
  final Color color;
  final String level;
  final String name;
  final int estimatedPounds;

  const HotspotData({
    required this.position,
    required this.intensity,
    required this.color,
    required this.level,
    required this.name,
    required this.estimatedPounds,
  });
}

class _HotspotWidget extends StatefulWidget {
  final HotspotData hotspot;

  const _HotspotWidget({
    Key? key,
    required this.hotspot,
  }) : super(key: key);

  @override
  State<_HotspotWidget> createState() => _HotspotWidgetState();
}

class _HotspotWidgetState extends State<_HotspotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 40.0 + (widget.hotspot.intensity * 20);

    return GestureDetector(
      onTap: () => _showHotspotDialog(context),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.hotspot.color.withOpacity(0.8),
                    widget.hotspot.color.withOpacity(0.4),
                    widget.hotspot.color.withOpacity(0.1),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.hotspot.color.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: size * 0.6,
                  height: size * 0.6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.hotspot.color,
                  ),
                  child: Center(
                    child: Text(
                      '${(widget.hotspot.intensity * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showHotspotDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_on,
              color: widget.hotspot.color,
            ),
            const SizedBox(width: 8),
            Text(
              widget.hotspot.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.hotspot.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: widget.hotspot.color),
              ),
              child: Text(
                widget.hotspot.level,
                style: TextStyle(
                  color: widget.hotspot.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  color: widget.hotspot.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.hotspot.estimatedPounds} lbs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Estimated trash in this area',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.hotspot.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: widget.hotspot.color.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: widget.hotspot.color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Intensity: ${(widget.hotspot.intensity * 100).round()}%',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CLOSE',
              style: TextStyle(
                color: Colors.white54,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to cleanup screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.hotspot.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'START CLEANUP',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}