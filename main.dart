import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/trash_heat_map_overlay.dart';

void main() {
  runApp(const HotspotDemoApp());
}

class HotspotDemoApp extends StatelessWidget {
  const HotspotDemoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trash Hotspots Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HotspotDemoScreen(),
    );
  }
}

class HotspotDemoScreen extends StatefulWidget {
  const HotspotDemoScreen({Key? key}) : super(key: key);

  @override
  State<HotspotDemoScreen> createState() => _HotspotDemoScreenState();
}

class _HotspotDemoScreenState extends State<HotspotDemoScreen> {
  bool _heatMapVisible = true;

  void _toggleHeatMap() {
    setState(() {
      _heatMapVisible = !_heatMapVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '🔥 Trash Hotspots Demo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ).animate()
         .shimmer(duration: 2.seconds, color: Colors.orange.withOpacity(0.3)),
        backgroundColor: Colors.black,
              elevation: 0,
      ),
      body: Stack(
        children: [
          // Background simulation
              Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
                  Colors.grey[900]!,
                  Colors.grey[800]!,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
              ),
            ),
            child: Center(
                          child: Text(
                'NYC MAP BACKGROUND\n(Google Maps would be here)',
                textAlign: TextAlign.center,
                            style: TextStyle(
                  color: Colors.grey[600],
                              fontSize: 18,
                  fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
          ),
          
          // Stunning hotspot overlays
          if (_heatMapVisible)
            TrashHeatMapOverlay(
              isVisible: _heatMapVisible,
              onToggle: _toggleHeatMap,
            ),
          
          // Demo instructions
              Positioned(
            top: 100,
            left: 20,
            right: 20,
                child: Container(
              padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                    '🎯 Interactive Hotspot Demo',
                                style: TextStyle(
                      color: Colors.white,
                            fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  SizedBox(height: 8),
                  Text(
                    '• Tap any hotspot to see details\n• Different colors show intensity levels\n• Pulsing animations show activity\n• Shimmer effects for visual appeal',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                          ),
                        ),
                    ],
                  ),
            ).animate()
             .fadeIn(duration: 800.ms)
             .slideY(begin: -0.5, end: 0.0),
          ),
        ],
      ),
    );
  }
}
