import 'package:flutter/material.dart';
import 'dart:async';

/// Main Scan UI screen
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isAnalyzing = false;
  bool _showResults = false;
  List<TrashItem> _detectedItems = [];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Main content area - shows camera preview or results
          Expanded(
            child: _isAnalyzing 
                ? _buildAnalyzingView() 
                : _showResults 
                    ? _buildResultsView()
                    : _buildCameraPreview(),
          ),
          
          // Camera/Gallery/Scan options - moved to bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircleButton(Icons.photo_library, () => _startScanProcess('gallery'), 60),
                const SizedBox(width: 16),
                _buildCircleButton(Icons.camera_alt, () => _startScanProcess('camera'), 80),
                const SizedBox(width: 16),
                _buildCircleButton(Icons.qr_code_scanner, () => _startScanProcess('scan'), 60),
              ],
            ),
          ),
          
          // Bottom button area
          if (_showResults)
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67D253),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 16)),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildCircleButton(IconData icon, VoidCallback onTap, double size) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade400,
        ),
        child: Icon(icon, color: Colors.white, size: size / 2),
      ),
    );
  }
  
  Widget _buildCameraPreview() {
    return Container(
      color: Colors.grey.shade200,
      child: const Center(
        child: Text('Camera Preview - Tap a button to start scanning',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
  
  Widget _buildAnalyzingView() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Progress indicator
          SizedBox(
            width: 100,
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey.shade200,
              color: Colors.green.shade200,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 32),
          
          // Analyzing text
          const Text(
            'Analyzing...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          
          // Instruction text
          const Text(
            'Please wait while we determine the proper\ndisposal method for this item.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildResultsView() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: _detectedItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = _detectedItems[index];
          return _ResultItem(
            item: item,
          );
        },
      ),
    );
  }
  
  void _startScanProcess(String source) {
    // Simulate the scanning process
    setState(() {
      _isAnalyzing = true;
      _showResults = false;
    });
    
    // In a real app, this would connect to camera or scan API
    // For demo, just simulate a delay and then show results
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _isAnalyzing = false;
        _showResults = true;
        _detectedItems = [
          TrashItem(
            name: 'Plastic Bottle',
            disposalMethod: DisposalMethod.recycle,
            icon: Icons.recycling,
            disposalText: 'Recyclable',
          ),
          TrashItem(
            name: 'Plastic Bag',
            disposalMethod: DisposalMethod.trash,
            icon: Icons.delete,
            disposalText: 'Dispose in trash',
          ),
        ];
      });
    });
  }
}

/// Disposal method options
enum DisposalMethod {
  recycle,
  trash,
  compost,
  hazardous,
}

/// Data class for a detected trash item
class TrashItem {
  final String name;
  final DisposalMethod disposalMethod;
  final IconData icon;
  final String disposalText;
  
  TrashItem({
    required this.name,
    required this.disposalMethod,
    required this.icon,
    required this.disposalText,
  });
}

/// Widget showing a single result item
class _ResultItem extends StatelessWidget {
  final TrashItem item;
  
  const _ResultItem({required this.item});
  
  @override
  Widget build(BuildContext context) {
    final Color iconColor = _getIconColor(item.disposalMethod);
    final Color bgColor = iconColor.withOpacity(0.1);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  item.disposalText,
                  style: TextStyle(
                    fontSize: 16,
                    color: iconColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getIconColor(DisposalMethod method) {
    switch (method) {
      case DisposalMethod.recycle:
        return Colors.green;
      case DisposalMethod.trash:
        return Colors.grey;
      case DisposalMethod.compost:
        return Colors.brown;
      case DisposalMethod.hazardous:
        return Colors.red;
    }
  }
}