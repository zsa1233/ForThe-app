import 'dart:ui';
import 'dart:async'; // Added for Completer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Added for Google Maps
import 'package:geolocator/geolocator.dart'; // Added for location
import 'package:permission_handler/permission_handler.dart'; // Added for permissions
import 'theme/app_theme.dart';
import 'cleanup_flow.dart';
import 'scan_flow.dart';
import 'widgets/aceternity_widgets.dart';
import 'data/services/mock_data_service.dart'; // Added for MockDataService
// Heat map imports
import 'models/trash_density_data.dart';
import 'services/trash_heat_map_service.dart';
import 'widgets/trash_heat_map_overlay.dart';
void main() {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run app with Riverpod
  runApp(
    const ProviderScope(
      child: TerraApp(),
    ),
  );
}

/// Root Terra application widget
class TerraApp extends StatelessWidget {
  const TerraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Terra - Cleanup Community',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system, // Let system decide the theme
      home: const HomeScreen(),
    );
  }
}

/// Home screen with bottom navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  
  final List<Widget> _screens = const [
    MapTab(),
    DashboardTab(),
    ScanTab(),
    LeaderboardTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _screens.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
    setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine if dark mode is active
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GradientText(
          'Terra',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: isDarkMode 
                ? Colors.black.withOpacity(0.5) 
                : Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex]
          .animate(key: ValueKey(_selectedIndex))
          .fadeIn(duration: 300.ms)
          .slide(begin: const Offset(0.05, 0), duration: 300.ms),
      ),
      bottomNavigationBar: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDarkMode 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              color: isDarkMode 
                ? Colors.black.withOpacity(0.5) 
                : Colors.white.withOpacity(0.5),
            ),
            child: NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
    setState(() {
                  _selectedIndex = index;
                  _tabController.animateTo(index);
                });
              },
              height: 70,
              elevation: 0,
              backgroundColor: Colors.transparent,
              destinations: [
                _buildNavDestination(Icons.map_outlined, Icons.map, 'Home', 0),
                _buildNavDestination(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', 1),
                _buildNavDestination(Icons.qr_code_scanner_outlined, Icons.qr_code_scanner, 'Scan', 2),
                _buildNavDestination(Icons.leaderboard_outlined, Icons.leaderboard, 'Leaderboard', 3),
                _buildNavDestination(Icons.person_outline, Icons.person, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
      // Floating action button removed since it's now on the map page directly
    );
  }
  
  // Custom navigation destination builder with animations
  NavigationDestination _buildNavDestination(
    IconData outlinedIcon, 
    IconData filledIcon, 
    String label, 
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    
    return NavigationDestination(
      icon: Icon(
        outlinedIcon,
        color: isSelected ? AppTheme.primaryColor : null,
      )
        .animate(target: isSelected ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(0.8, 0.8)),
      selectedIcon: Icon(
        filledIcon,
        color: AppTheme.primaryColor,
      )
        .animate()
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1))
        .then()
        .shimmer(duration: 0.5.seconds, color: Colors.white24),
      label: label,
    );
  }
}

// Tab screens
class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final MockDataService _dataService = MockDataService();
  final Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _locationPermissionGranted = false;
  String? _errorMessage;
  final Completer<GoogleMapController> _mapController = Completer();

  bool _heatMapVisible = true;  Set<Circle> _heatMapCircles = {};  // New York City coordinates as the initial map focus
  static const LatLng _nycCenter = LatLng(40.7128, -74.0060);


  // NYC bounds for validation
  static const double _nycNorthBound = 40.9176;
  static const double _nycSouthBound = 40.4774;
  static const double _nycEastBound = -73.7004;
  static const double _nycWestBound = -74.2591;  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  /// Initialize the map with permissions and data
  Future<void> _initializeMap() async {
    try {
      // Check and request location permissions
      await _checkLocationPermissions();
      
      // Load hotspot data
      await _loadHotspots();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize map: ${e.toString()}'; 
          _isLoading = false;
        });
      }
    }
  }  }  /// Create a custom marker for a hotspot
  Future<Marker> _createMarkerForHotspot(Map<String, dynamic> hotspot) async {
    final priority = hotspot['priority'] as String;
    final latitude = hotspot['location']['latitude'] as double;
    final longitude = hotspot['location']['longitude'] as double;
    final title = hotspot['title'] as String;
    final details = hotspot['details'] as String;
    final estimatedPounds = hotspot['estimated_pounds'] as double;
    
    // Create marker
    return Marker(
      markerId: MarkerId(hotspot['id'] as String),
      position: LatLng(latitude, longitude),
      infoWindow: InfoWindow(
        title: '$title - $priority Priority',
        snippet: '$details (Est: $estimatedPounds lbs)',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _getMarkerHueFromPriority(priority),
      ),
      onTap: () => _onHotspotTapped(hotspot),
    );
  }

  /// Convert priority string to marker color hue
  double _getMarkerHueFromPriority(String priority) {
    switch (priority) {
      case 'Critical':
        return BitmapDescriptor.hueRed;
      case 'High':
        return BitmapDescriptor.hueOrange;
      case 'Medium':
        return BitmapDescriptor.hueYellow;
      case 'Low':
        return BitmapDescriptor.hueGreen;
      default:
        return BitmapDescriptor.hueAzure;
    }
  }

  /// Handle hotspot marker tap
  void _onHotspotTapped(Map<String, dynamic> hotspot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildHotspotDetailSheet(hotspot),
    );
  }

  /// Build hotspot detail bottom sheet
  Widget _buildHotspotDetailSheet(Map<String, dynamic> hotspot) {
    final priority = hotspot['priority'] as String;
    final Color priorityColor = _getPriorityColor(priority);
    final title = hotspot['title'] as String;
    final details = hotspot['details'] as String;
    final estimatedPounds = hotspot['estimated_pounds'] as double;
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '$priority Priority',
                  style: TextStyle(
                    color: priorityColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Est: ${estimatedPounds.toStringAsFixed(1)} lbs',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            details,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),

  /// Toggle heat map visibility
  void _toggleHeatMap() {
    setState(() {
      _heatMapVisible = !_heatMapVisible;
    });
  }          const SizedBox(height: 24),
          PulseButton(
            onPressed: () {
              Navigator.pop(context); // Close bottom sheet
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CleanupStartScreen(hotspotId: hotspot['id'] as String),
                ),
              );
            },
            label: 'Start Cleanup at this Location',
            icon: Icons.add_location,
            gradient: AppTheme.primaryGradient,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Critical': return Colors.red;
      case 'High': return Colors.orange;
      case 'Medium': return Colors.amber;
      case 'Low': return Colors.green;
      default: return Colors.blue;
    }
  }


  /// Validate if coordinates are within NYC bounds
  bool _isWithinNYCBounds(double latitude, double longitude) {
    return latitude >= _nycSouthBound &&
           latitude <= _nycNorthBound &&
           longitude >= _nycWestBound &&
           longitude <= _nycEastBound;
  }

  /// Go to user's current location (NYC area only)
  Future<void> _goToUserLocation() async {
    if (!_locationPermissionGranted) {
      // Request permission again
      await _checkLocationPermissions();
      if (!_locationPermissionGranted) {
        _showPermissionDialog();
        return;
      }
    }

    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      // Validate that user location is within NYC bounds
      if (!_isWithinNYCBounds(position.latitude, position.longitude)) {
        _showLocationErrorDialog(
          'Your current location is outside New York City. '
          'This app is designed specifically for NYC cleanup activities. '
          'Returning to NYC overview.',
        );
        
        // Return to NYC center view
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(_nycCenter, 11.5),
        );
        return;
      }
      
      final GoogleMapController controller = await _mapController.future;
      
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          15,
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        _showLocationErrorDialog('Could not get your location: ${e.toString()}');
      }
    }
  }

  /// Show location error using SelectableText.rich as per Flutter guidelines
  void _showLocationErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Error'),
        content: SelectableText.rich(
          TextSpan(
            text: message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Show error state if there's an error
    if (_errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Map Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = null;
                });
                _initializeMap();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        // Google Maps widget with NYC bounds constraints
        GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: _nycCenter,
            zoom: 11.5, // Zoomed to show most of NYC
          ),
          markers: _markers,
          myLocationEnabled: _locationPermissionGranted,          myLocationButtonEnabled: false, // We'll use our custom button
          compassEnabled: true,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          minMaxZoomPreference: const MinMaxZoomPreference(9.0, 18.0),
          cameraTargetBounds: CameraTargetBounds(
            LatLngBounds(
              southwest: const LatLng(40.4774 - 0.05, -74.2591 - 0.05), // NYC South-West with buffer
              northeast: const LatLng(40.9176 + 0.05, -73.7004 + 0.05), // NYC North-East with buffer
            ),
          ),
          onMapCreated: (GoogleMapController controller) {
            debugPrint('Google Map created successfully with NYC bounds');
            _mapController.complete(controller);
          },
        ),
        
        // Loading indicator
        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading NYC Hotspots...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        // Controls column - right side
        Positioned(
          right: 16,
          bottom: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Zoom in button
              FloatingActionButton.small(
                heroTag: 'zoomIn',
                onPressed: () async {
                  final controller = await _mapController.future;
                  controller.animateCamera(CameraUpdate.zoomIn());
                },
                child: const Icon(Icons.add),
              ),
              const SizedBox(height: 8),
              
              // Zoom out button
              FloatingActionButton.small(
                heroTag: 'zoomOut',
                onPressed: () async {
                  final controller = await _mapController.future;
                  controller.animateCamera(CameraUpdate.zoomOut());
                },
                child: const Icon(Icons.remove),
              ),
              const SizedBox(height: 16),
              
              // My location button
              FloatingActionButton.small(
                heroTag: 'myLocation',
                onPressed: _goToUserLocation,
                backgroundColor: _locationPermissionGranted 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[300],
                child: Icon(
                  Icons.my_location,
                  color: _locationPermissionGranted 
                      ? Colors.white 
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              
              
              // Heat map toggle button
              FloatingActionButton.small(
                heroTag: 'heatMapToggle',
                onPressed: _toggleHeatMap,
                backgroundColor: _heatMapVisible 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[300],
                child: Icon(
                  Icons.layers,
                  color: _heatMapVisible 
                      ? Colors.white 
                      : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              
              // Reset to NYC button
              FloatingActionButton.small(
                heroTag: 'resetView',
                onPressed: () async {
                  final controller = await _mapController.future;
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(_nycCenter, 11.5),
                  );
                },
                child: const Icon(Icons.home),
              ),
            ],
        ),          ),
        
        // Stunning hotspot overlays
        if (_heatMapVisible)
          TrashHeatMapOverlay(
            isVisible: _heatMapVisible,
            onToggle: _toggleHeatMap,
          ),        
        // Start Cleanup button positioned at the bottom
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Center(
            child: PulseButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CleanupStartScreen(),
                  ),
                );
              },
              label: 'Start Cleanup',
              icon: Icons.add_location,
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              width: 200,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tab for scanning items to determine disposal method
class ScanTab extends StatelessWidget {
  const ScanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            isDarkMode ? Colors.black : Colors.white,
            isDarkMode ? Colors.black : const Color(0xFFF0F8FF),
          ],
                ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add some height to ensure scrolling works
                const SizedBox(height: 50),
                const Icon(
                  Icons.qr_code_scanner,
                  size: 80,
                  color: AppTheme.secondaryColor,
                ),
                
                const SizedBox(height: 32),
                
                GradientText(
                  'Scan to identify trash items',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: AppTheme.accentGradient,
                ),
                
                const SizedBox(height: 16),
                
                const Text(
                  'Use the camera to scan items and learn how to properly dispose of them',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                
                const SizedBox(height: 48),
                
                TiltCard(
                  padding: EdgeInsets.zero,
                  child: PulseButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ScanScreen(),
                        ),
                      );
                    },
                    label: 'Start Scanning',
                    icon: Icons.camera_alt,
                    width: double.infinity,
                    height: 60,
                    gradient: AppTheme.accentGradient,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Center(
                  child: Text(
                    'Not sure what to recycle? Scan it!',
                    style: TextStyle(
                      fontSize: 14, 
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ),
                
                // Add extra space to ensure scrolling works
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDarkMode ? AppTheme.backgroundColor : Colors.white,
            isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
          ],
        ),
      ),
      child: SafeArea(
        // Ensure the content is scrollable
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting and summary
              TiltCard(
                tiltFactor: 0.03,
                color: isDarkMode ? AppTheme.cardColor : Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: Text(
                            'JD',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
            Text(
                              'Welcome Back, John!',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Level 8 · Eco Warrior',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
            ),
          ],
        ),
                      ],
                    ),
                    const Divider(height: 32),
                    Text(
                      'Your Impact',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildImpactMetric(
                          context, 
                          '136', 
                          'pounds collected',
                          AppTheme.primaryColor,
                        ),
                        _buildImpactMetric(
                          context, 
                          '12', 
                          'cleanups joined',
                          AppTheme.secondaryColor,
                        ),
                        _buildImpactMetric(
                          context, 
                          '7', 
                          'day streak',
                          AppTheme.accentColor,
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, curve: Curves.easeOut)
              .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 24),
              
              // Stats section title
              GradientText(
                'Your Stats',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),
              
              const SizedBox(height: 16),
              
              // Stats grid
              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildStatCard(
                    context,
                    '12',
                    'Cleanups',
                    AppTheme.primaryColor,
                    Icons.eco,
                    isDarkMode,
                  ),
                  _buildStatCard(
                    context,
                    '89',
                    'Lbs Collected',
                    AppTheme.secondaryColor,
                    Icons.fitness_center,
                    isDarkMode,
                  ),
                  _buildStatCard(
                    context,
                    '7',
                    'Day Streak',
                    AppTheme.accentColor,
                    Icons.local_fire_department,
                    isDarkMode,
                  ),
                  _buildStatCard(
                    context,
                    '156',
                    'Community Rank',
                    Colors.purple,
                    Icons.people,
                    isDarkMode,
                  ),
                ]
                .animate()
                .fadeIn(delay: 300.ms, duration: 400.ms)
                .slideX(begin: 0.1, end: 0, delay: 300.ms, duration: 400.ms),
              ),
              
              const SizedBox(height: 24),
              
              // Recent activity
              GradientText(
                'Recent Activity',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms),
              
              const SizedBox(height: 16),
              
              // Activity list
              GlassCard(
                child: Column(
                  children: [
                    _buildActivityItem(
                      context,
                      'Beach Cleanup',
                      'You collected 5.2 lbs of trash',
                      '2 days ago',
                      Icons.beach_access,
                      AppTheme.primaryColor,
                    ),
                    const Divider(height: 24),
                    _buildActivityItem(
                      context,
                      'Badge Earned',
                      'You earned the "7-Day Streak" badge',
                      '3 days ago',
                      Icons.emoji_events,
                      Colors.amber,
                    ),
                    const Divider(height: 24),
                    _buildActivityItem(
                      context,
                      'Joined Cleanup',
                      'You joined "Park Restoration" cleanup',
                      '5 days ago',
                      Icons.group_add,
                      AppTheme.secondaryColor,
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms)
              .slideY(begin: 0.1, end: 0, delay: 500.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildImpactMetric(BuildContext context, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(BuildContext context, String value, String label, Color color, IconData icon, bool isDarkMode) {
    return GradientBorderCard(
      gradient: LinearGradient(
        colors: [color, color.withOpacity(0.7)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      backgroundColor: isDarkMode ? AppTheme.cardColor : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon, 
                  color: color, 
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
            Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActivityItem(BuildContext context, String title, String subtitle, String time, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }
}

class LeaderboardTab extends StatelessWidget {
  const LeaderboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample leaderboard data
    final List<Map<String, dynamic>> topUsers = [
      {'rank': 1, 'name': 'Sarah Johnson', 'points': 1250, 'avatar': 'SJ', 'change': 0},
      {'rank': 2, 'name': 'Michael Chen', 'points': 1180, 'avatar': 'MC', 'change': 1},
      {'rank': 3, 'name': 'Emma Wilson', 'points': 1105, 'avatar': 'EW', 'change': -1},
      {'rank': 4, 'name': 'James Brown', 'points': 950, 'avatar': 'JB', 'change': 2},
      {'rank': 5, 'name': 'Olivia Davis', 'points': 890, 'avatar': 'OD', 'change': 0},
      {'rank': 6, 'name': 'Noah Smith', 'points': 830, 'avatar': 'NS', 'change': 4},
      {'rank': 7, 'name': 'Sophia Garcia', 'points': 775, 'avatar': 'SG', 'change': -2},
      {'rank': 8, 'name': 'John Doe', 'points': 760, 'avatar': 'JD', 'change': 0},
      {'rank': 9, 'name': 'Ava Martinez', 'points': 710, 'avatar': 'AM', 'change': 1},
      {'rank': 10, 'name': 'William Lee', 'points': 680, 'avatar': 'WL', 'change': -3},
    ];
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDarkMode ? AppTheme.backgroundColor : Colors.white,
            isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
          ],
        ),
      ),
      // Make the entire screen scrollable
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Leaderboard title and period
                GradientText(
                  'Community Leaders',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  gradient: AppTheme.primaryGradient,
                ),
                const SizedBox(height: 8),
                Text(
                  'June 2023 | This Month',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Top 3 section with podium - Fixed height to prevent overflow
                SizedBox(
                  height: 171, // Added 1 extra pixel to prevent overflow
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 2nd place
                      _buildTopUserCard(
                        context, 
                        topUsers[1], 
                        130, // Further reduced height
                        AppTheme.secondaryColor,
                        isDarkMode,
                      ),
                      const SizedBox(width: 12),
                      // 1st place
                      _buildTopUserCard(
                        context, 
                        topUsers[0], 
                        150, // Further reduced height
                        AppTheme.primaryColor,
                        isDarkMode,
                        isCrown: true,
                      ),
                      const SizedBox(width: 12),
                      // 3rd place
                      _buildTopUserCard(
                        context, 
                        topUsers[2], 
                        110, // Further reduced height
                        AppTheme.accentColor,
                        isDarkMode,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Rest of the leaderboard - Now in a fixed height container
                SizedBox(
                  height: 300, // Fixed height for the list
                  child: SpotlightCard(
                    borderRadius: AppTheme.largeBorderRadius,
                    spotlightSize: 200,
                    spotlightColor: AppTheme.primaryColor,
                    padding: EdgeInsets.zero,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: topUsers.length - 3,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final user = topUsers[index + 3];
                        return _buildLeaderboardItem(context, user);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTopUserCard(
    BuildContext context, 
    Map<String, dynamic> user, 
    double height, 
    Color color,
    bool isDarkMode,
    {bool isCrown = false}
  ) {
    // Use ClipRect at the top level to ensure nothing overflows
    return ClipRect(
      child: Column(
        mainAxisSize: MainAxisSize.min,
      children: [
        if (isCrown)
          Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 20, // Smaller crown icon
          )
            .animate()
            .scale(duration: 400.ms, curve: Curves.easeOut)
            .then()
            .shimmer(duration: 1.seconds, color: Colors.white24)
        else
          const SizedBox(height: 20), // Reduced empty space
          
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 80,
              height: height,
              clipBehavior: Clip.antiAlias, // Added clipping to prevent overflow
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(2), // Reduced padding
              child: ClipRect(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  CircleAvatar(
                    backgroundColor: isDarkMode ? Colors.white10 : Colors.white,
                    radius: 12, // Reduced radius
                    child: Text(
                      user['avatar'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced spacing
                  Text(
                    user['name'].split(' ')[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9, // Reduced font size
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 1), // Reduced spacing
                  Text(
                    '${user['points']} pts',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8, // Reduced font size
                    ),
                  ),
                  const SizedBox(height: 4), // Reduced spacing
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4), // Smaller radius
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 1, // Reduced vertical padding
                      horizontal: 3, // Reduced horizontal padding
                    ),
                    child: Text(
                      '#${user['rank']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 9, // Smaller font size
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ),
            
            // Change indicator
            if (user['change'] != 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: user['change'] > 0 ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    user['change'] > 0 ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
          ],
        ),
      ],
    ),
    );  // Closing ClipRect
  }
  
  Widget _buildLeaderboardItem(BuildContext context, Map<String, dynamic> user) {
    final rankColor = user['rank'] < 5 
        ? AppTheme.primaryColor 
        : Theme.of(context).textTheme.bodyLarge?.color;
        
    final changeIcon = user['change'] == 0
        ? Icon(Icons.remove, size: 12, color: Colors.grey[600])
        : user['change'] > 0
            ? Icon(Icons.arrow_upward, size: 12, color: Colors.green)
            : Icon(Icons.arrow_downward, size: 12, color: Colors.red);
            
    final changeText = user['change'] == 0
        ? '-'
        : user['change'] > 0
            ? '+${user['change']}'
            : '${user['change']}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            alignment: Alignment.center,
            child: Text(
              '${user['rank']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rankColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              user['avatar'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
      title: Text(
        user['name'],
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Row(
        children: [
          changeIcon,
          const SizedBox(width: 4),
          Text(
            changeText,
            style: TextStyle(
              color: user['change'] == 0
                  ? Colors.grey[600]
                  : user['change'] > 0
                      ? Colors.green
                      : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Text(
        '${user['points']} pts',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample user data
    const userName = 'John Doe';
    const userLevel = 'Level 8';
    const userTitle = 'Eco Warrior';
    const userLocation = 'San Francisco, CA';
    const userJoined = 'Joined March 2023';
    
    // Sample badges
    final badges = [
      {'name': 'First Cleanup', 'icon': Icons.eco, 'color': AppTheme.primaryColor, 'earned': true},
      {'name': '50 lbs Club', 'icon': Icons.fitness_center, 'color': AppTheme.secondaryColor, 'earned': true},
      {'name': '7-Day Streak', 'icon': Icons.local_fire_department, 'color': AppTheme.accentColor, 'earned': true},
      {'name': '100 lbs Club', 'icon': Icons.sentiment_very_satisfied, 'color': Colors.purple, 'earned': false},
      {'name': 'Volunteer', 'icon': Icons.favorite, 'color': Colors.red, 'earned': true},
      {'name': 'Plastic Fighter', 'icon': Icons.beach_access, 'color': Colors.blue, 'earned': false},
    ];
    
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isDarkMode ? AppTheme.backgroundColor : Colors.white,
            isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
          ],
        ),
      ),
      // Ensure the content is scrollable with bouncing physics
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile header with user info
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                child: Text(
                  'JD',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              )
              .animate()
              .scale(duration: 500.ms, curve: Curves.easeOut),
              
              const SizedBox(height: 16),
              
              GradientText(
                userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
              .animate()
              .fadeIn(delay: 100.ms, duration: 500.ms),
              
              const SizedBox(height: 4),
              
              Text(
                '$userLevel · $userTitle',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms),
              
              const SizedBox(height: 4),
              
              Text(
                '$userLocation · $userJoined',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms),
              
              const SizedBox(height: 24),
              
              // User stats cards
              Row(
                children: [
                  Expanded(
                    child: _buildProfileStatCard(
                      context, 
                      '12', 
                      'Cleanups',
                      Icons.clean_hands,
                      isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProfileStatCard(
                      context, 
                      '136', 
                      'Lbs Collected',
                      Icons.delete,
                      isDarkMode,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProfileStatCard(
                      context, 
                      '5/9', 
                      'Badges',
                      Icons.emoji_events,
                      isDarkMode,
                    ),
                  ),
                ],
              )
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms),
              
              const SizedBox(height: 32),
              
              // Badge Progress Section
              SpotlightCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Badge Progress',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple.withOpacity(0.1),
                            border: Border.all(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.purple,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '100 lbs Club',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '136 / 200 lbs collected',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: 136 / 200, // 68% progress
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.purple,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '64 lbs to go!',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 450.ms, duration: 500.ms),
              
              const SizedBox(height: 32),
              
              // Badges section
              Row(
                children: [
                  Text(
                    'Earned Badges',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                                                TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AllBadgesScreen(),
                                    ),
                                  );
                                },
                                child: const Text('View All'),
                              ),
                ],
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 400.ms),
              
              const SizedBox(height: 16),
              
              // Badges grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: badges.length,
                itemBuilder: (context, index) {
                  final badge = badges[index];
                  return _buildBadge(
                    context,
                    badge['name'] as String,
                    badge['icon'] as IconData,
                    badge['color'] as Color,
                    badge['earned'] as bool,
                    isDarkMode,
                  );
                },
              )
              .animate()
              .fadeIn(delay: 600.ms, duration: 400.ms),
              
              const SizedBox(height: 32),
              
              // Settings buttons
                                        Row(
                            children: [
                              Expanded(
                                child: TiltCard(
                                  padding: EdgeInsets.zero,
                                  child: PulseButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const EditProfileScreen(),
                                        ),
                                      );
                                    },
                                    label: 'Edit Profile',
                                    icon: Icons.edit,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade700,
                                        Colors.grey.shade500,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TiltCard(
                                  padding: EdgeInsets.zero,
                                  child: PulseButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SettingsScreen(),
                                        ),
                                      );
                                    },
                                    label: 'Settings',
                                    icon: Icons.settings,
                                    gradient: AppTheme.accentGradient,
                                  ),
                                ),
                              ),
                            ],
                          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildProfileStatCard(BuildContext context, String value, String label, IconData icon, bool isDarkMode) {
    return SpotlightCard(
      color: isDarkMode ? AppTheme.cardColor : Colors.white,
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 18,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBadge(BuildContext context, String name, IconData icon, Color color, bool earned, bool isDarkMode) {
    return TiltCard(
      padding: const EdgeInsets.all(8),
      color: isDarkMode ? AppTheme.cardColor : Colors.white,
      tiltFactor: 0.05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: earned ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
              border: Border.all(
                color: earned ? color : Colors.grey,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: earned ? color : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: earned 
                ? Theme.of(context).textTheme.bodyLarge?.color
                : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (!earned)
            Text(
              'Locked',
              style: TextStyle(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
            ),
        ],
      ),
    );
  }
}

// Edit Profile Screen
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _locationController = TextEditingController(text: 'San Francisco, CA');
  final _bioController = TextEditingController(text: 'Environmental enthusiast and cleanup warrior!');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDarkMode ? AppTheme.backgroundColor : Colors.white,
              isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(20.0),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture Section
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                        child: Text(
                          'JD',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              // TODO: Implement image picker
                            },
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Form Fields
                GlassCard(
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _locationController,
                        label: 'Location',
                        icon: Icons.location_on,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _bioController,
                        label: 'Bio',
                        icon: Icons.info,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Save Button
                TiltCard(
                  padding: EdgeInsets.zero,
                  child: PulseButton(
                    onPressed: () {
                      // Validate and sanitize user input before saving
                      final name = _nameController.text.trim();
                      final email = _emailController.text.trim();
                      final location = _locationController.text.trim();
                      final bio = _bioController.text.trim();
                      
                      // Input validation
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Name cannot be empty'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      if (email.isNotEmpty && !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a valid email'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      
                      // TODO: Implement actual save functionality with secure storage
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile updated successfully!'),
                          backgroundColor: AppTheme.primaryColor,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    label: 'Save Changes',
                    icon: Icons.save,
                    gradient: AppTheme.primaryGradient,
                    width: double.infinity,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor),
        ),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;
  bool _autoBackupEnabled = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDarkMode ? AppTheme.backgroundColor : Colors.white,
              isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Notifications Section
                SpotlightCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications, color: AppTheme.primaryColor),
                          const SizedBox(width: 12),
            Text(
                            'Notifications',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
            ),
          ],
        ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive cleanup reminders and updates',
                        value: _notificationsEnabled,
                        onChanged: (value) => setState(() => _notificationsEnabled = value),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Privacy Section
                SpotlightCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.privacy_tip, color: AppTheme.secondaryColor),
                          const SizedBox(width: 12),
                          Text(
                            'Privacy',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        title: 'Location Services',
                        subtitle: 'Allow location access for nearby cleanups',
                        value: _locationEnabled,
                        onChanged: (value) => setState(() => _locationEnabled = value),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Appearance Section
                SpotlightCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.palette, color: AppTheme.accentColor),
                          const SizedBox(width: 12),
                          Text(
                            'Appearance',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: _darkModeEnabled,
                        onChanged: (value) => setState(() => _darkModeEnabled = value),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Data Section
                SpotlightCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.storage, color: Colors.purple),
                          const SizedBox(width: 12),
                          Text(
                            'Data & Storage',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildSettingsTile(
                        title: 'Auto Backup',
                        subtitle: 'Automatically backup your data',
                        value: _autoBackupEnabled,
                        onChanged: (value) => setState(() => _autoBackupEnabled = value),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Action Buttons
                GradientBorderCard(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.help, color: AppTheme.secondaryColor),
                        title: const Text('Help & Support'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navigate to help screen
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info, color: AppTheme.primaryColor),
                        title: const Text('About'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('About Terra'),
                              content: const Text('Terra v1.0.0\nCommunity-driven environmental cleanup app'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: AppTheme.accentColor),
                        title: const Text('Sign Out'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Sign Out'),
                              content: const Text('Are you sure you want to sign out?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close dialog
                                    
                                    // Perform secure sign out with proper state cleanup
                                    // 1. Clear secure storage/credentials
                                    // 2. Clear sensitive in-memory data
                                    // 3. Reset app state
                                    
                                    // Simulating secure sign out for demo
                                    Future.delayed(const Duration(milliseconds: 300), () {
                                      // Using proper navigation patterns - avoid back stack issues
                                      Navigator.popUntil(context, (route) => route.isFirst);
                                      
                                      // Show confirmation to user
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Signed out securely'),
                                          backgroundColor: AppTheme.primaryColor,
                                        ),
                                      );
                                    });
                                  },
                                  child: const Text('Sign Out', style: TextStyle(color: AppTheme.accentColor)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 50), // Extra space for scrolling
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// All Badges Screen
class AllBadgesScreen extends StatelessWidget {
  const AllBadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Complete badge system with requirements
    final allBadges = [
      {
        'name': 'First Cleanup',
        'icon': Icons.eco,
        'color': AppTheme.primaryColor,
        'requirement': '5 lbs',
        'description': 'Complete your first cleanup activity',
        'category': 'Beginner',
        'earned': true,
        'userProgress': 136.0,
        'requiredAmount': 5.0,
      },
      {
        'name': '50 lbs Club',
        'icon': Icons.fitness_center,
        'color': AppTheme.secondaryColor,
        'requirement': '50 lbs',
        'description': 'Collect 50 pounds of trash',
        'category': 'Achievement',
        'earned': true,
        'userProgress': 136.0,
        'requiredAmount': 50.0,
      },
      {
        'name': '7-Day Streak',
        'icon': Icons.local_fire_department,
        'color': AppTheme.accentColor,
        'requirement': '7 consecutive days',
        'description': 'Clean up for 7 days in a row',
        'category': 'Streak',
        'earned': true,
        'userProgress': 7.0,
        'requiredAmount': 7.0,
      },
      {
        'name': '100 lbs Club',
        'icon': Icons.sentiment_very_satisfied,
        'color': Colors.purple,
        'requirement': '100 lbs',
        'description': 'Collect 100 pounds of trash',
        'category': 'Achievement',
        'earned': false,
        'userProgress': 136.0,
        'requiredAmount': 100.0,
      },
      {
        'name': 'Volunteer',
        'icon': Icons.favorite,
        'color': Colors.red,
        'requirement': '10 community events',
        'description': 'Participate in 10 community cleanup events',
        'category': 'Community',
        'earned': true,
        'userProgress': 12.0,
        'requiredAmount': 10.0,
      },
      {
        'name': 'Plastic Fighter',
        'icon': Icons.beach_access,
        'color': Colors.blue,
        'requirement': '25 lbs plastic',
        'description': 'Collect 25 pounds of plastic waste',
        'category': 'Specialist',
        'earned': false,
        'userProgress': 15.0,
        'requiredAmount': 25.0,
      },
      {
        'name': '200 lbs Club',
        'icon': Icons.workspace_premium,
        'color': Colors.amber,
        'requirement': '200 lbs',
        'description': 'Collect 200 pounds of trash',
        'category': 'Expert',
        'earned': false,
        'userProgress': 136.0,
        'requiredAmount': 200.0,
      },
      {
        'name': 'Team Leader',
        'icon': Icons.group,
        'color': Colors.orange,
        'requirement': 'Lead 5 cleanups',
        'description': 'Organize and lead 5 cleanup activities',
        'category': 'Leadership',
        'earned': false,
        'userProgress': 2.0,
        'requiredAmount': 5.0,
      },
      {
        'name': 'Eco Champion',
        'icon': Icons.eco,
        'color': Colors.green,
        'requirement': '500 lbs',
        'description': 'Collect 500 pounds of trash',
        'category': 'Master',
        'earned': false,
        'userProgress': 136.0,
        'requiredAmount': 500.0,
      },
      {
        'name': '30-Day Warrior',
        'icon': Icons.calendar_today,
        'color': Colors.deepPurple,
        'requirement': '30 consecutive days',
        'description': 'Clean up for 30 days in a row',
        'category': 'Streak',
        'earned': false,
        'userProgress': 7.0,
        'requiredAmount': 30.0,
      },
    ];

    // Group badges by category
    final badgeCategories = <String, List<Map<String, dynamic>>>{};
    for (final badge in allBadges) {
      final category = badge['category'] as String;
      badgeCategories.putIfAbsent(category, () => []).add(badge);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Badges'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDarkMode ? AppTheme.backgroundColor : Colors.white,
              isDarkMode ? AppTheme.backgroundColor.withOpacity(0.8) : const Color(0xFFF9FFFD),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Stats
                SpotlightCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '5',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const Text('Earned', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${allBadges.length}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.secondaryColor,
                              ),
                            ),
                            const Text('Total', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              '${((5 / allBadges.length) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.accentColor,
                              ),
                            ),
                            const Text('Complete', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Badge Categories
                ...badgeCategories.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...entry.value.map((badge) => _buildBadgeCard(context, badge, isDarkMode)),
                      const SizedBox(height: 16),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeCard(BuildContext context, Map<String, dynamic> badge, bool isDarkMode) {
    final earned = badge['earned'] as bool;
    final userProgress = badge['userProgress'] as double;
    final requiredAmount = badge['requiredAmount'] as double;
    final progressPercentage = (userProgress / requiredAmount).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GradientBorderCard(
        backgroundColor: isDarkMode ? AppTheme.cardColor : Colors.white,
        child: Row(
          children: [
            // Badge Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: earned 
                  ? (badge['color'] as Color).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
                border: Border.all(
                  color: earned ? badge['color'] as Color : Colors.grey,
                  width: 2,
                ),
              ),
              child: Icon(
                badge['icon'] as IconData,
                color: earned ? badge['color'] as Color : Colors.grey,
                size: 28,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Badge Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          badge['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: earned 
                              ? Theme.of(context).textTheme.bodyLarge?.color
                              : Colors.grey,
                          ),
                        ),
                      ),
                      if (earned)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'EARNED',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    badge['description'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Requirement: ${badge['requirement']}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: badge['color'] as Color,
                        ),
                      ),
                      const Spacer(),
                      if (!earned)
                        Text(
                          '${(progressPercentage * 100).round()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: badge['color'] as Color,
                          ),
                        ),
                    ],
                  ),
                  if (!earned) ...[
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        badge['color'] as Color,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}