import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class NIDScanFrontScreen extends StatefulWidget {
  const NIDScanFrontScreen({Key? key}) : super(key: key);

  @override
  _NIDScanFrontScreenState createState() => _NIDScanFrontScreenState();
}

class _NIDScanFrontScreenState extends State<NIDScanFrontScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isCaptureInProgress = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      _showErrorDialog('Error initializing camera: $e');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      _showErrorDialog('Error: Camera controller not initialized');
      return;
    }

    if (_isCaptureInProgress) {
      _showErrorDialog('Capture already in progress');
      return;
    }

    setState(() {
      _isCaptureInProgress = true;
    });

    try {
      await _initializeControllerFuture;
      final XFile image = await _controller!.takePicture();
      
      // Instead of using getApplicationDocumentsDirectory, we'll use a temporary directory
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String imagePath = 'nid_front_$timestamp.jpg';
      
      // Return the image path directly
      Navigator.pop(context, image.path);
    } catch (e) {
      _showErrorDialog('Error capturing image: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isCaptureInProgress = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text(message, style: GoogleFonts.poppins()),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: GoogleFonts.poppins()),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Front of NID', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF4285F4),
      ),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: CameraPreview(_controller!),
                        ),
                      ),
                      // Add overlay guide for NID placement
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: const EdgeInsets.all(32),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Place your NID card within the frame',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 14,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _isCaptureInProgress ? null : _captureImage,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4285F4),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  _isCaptureInProgress ? 'Capturing...' : 'Capture Front of NID',
                                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}