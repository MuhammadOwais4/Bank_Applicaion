import 'package:bank_application/Screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'nid_scan_front_screen.dart';
import 'nid_scan_back_screen.dart';

class NIDScanScreen extends StatefulWidget {
  const NIDScanScreen({super.key});

  @override
  _NIDScanScreenState createState() => _NIDScanScreenState();
}

class _NIDScanScreenState extends State<NIDScanScreen> {
  String? _frontImagePath;
  String? _backImagePath;

  Future<void> _onFrontScanned() async {
    try {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const NIDScanFrontScreen()),
      );
      if (result != null) {
        setState(() {
          _frontImagePath = result;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Front of NID captured successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error capturing front of NID: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture front of NID'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _onBackScanned() async {
    try {
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (context) => const NIDScanBackScreen()),
      );
      if (result != null) {
        setState(() {
          _backImagePath = result;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Back of NID captured successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      print('Error capturing back of NID: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to capture back of NID'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  bool get _isScanComplete => _frontImagePath != null && _backImagePath != null;

  Widget _buildImageWidget(String imagePath) {
    if (kIsWeb) {
      // For web, use network image or asset image depending on your setup
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[400],
            ),
          );
        },
      );
    } else {
      // For mobile platforms, use file image
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey[400],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressIndicator(),
              const SizedBox(height: 32),
              Text(
                'Scan Your NID',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Front Side',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildScanCard(_frontImagePath, _onFrontScanned, 'Front Side of NID'),
              const SizedBox(height: 24),
              Text(
                'Back Side',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              _buildScanCard(_backImagePath, _onBackScanned, 'Back Side of NID'),
              const SizedBox(height: 32),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFF4285F4),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '2',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 20,
            height: 2,
            color: const Color(0xFF4285F4),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '3',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(String? imagePath, VoidCallback onTap, String title) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: imagePath == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Scan $title',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                )
              : Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _buildImageWidget(imagePath),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: onTap,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

Widget _buildNextButton() {
  return SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isScanComplete
          ? () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4285F4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        disabledBackgroundColor: Colors.grey[300],
      ),
      child: Text(
        'Next',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _isScanComplete ? Colors.white : Colors.grey[600],
        ),
      ),
    ),
  );
}
}