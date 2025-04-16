import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class TryPage extends StatefulWidget {
  const TryPage({super.key});

  @override
  State<TryPage> createState() => _TryPageState();
}

class _TryPageState extends State<TryPage> {
  late final List<CameraDescription> cameras;
  late CameraController _controller;
  late PoseDetector _poseDetector;
  int _cameraIndex = 0;
  bool _isCameraInitialized = false;

  CameraImage? _latestImage;
  Timer? _poseTimer;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );
    _initEverything();
  }

  Future<void> _initEverything() async {
    try {
      cameras = await availableCameras();
      await _initializeCamera(_cameraIndex);

      _poseTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (_latestImage != null && !_isProcessing) {
          _processCameraImage(_latestImage!);
        }
      });
    } catch (e) {
      debugPrint('Camera setup error: $e');
    }
  }

  Future<void> _initializeCamera(int index) async {
    _controller = CameraController(
      cameras[index],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      if (!mounted) return;

      setState(() => _isCameraInitialized = true);

      await _controller.startImageStream((image) {
        _latestImage = image;
      });
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _flipCamera() async {
    setState(() => _isCameraInitialized = false);
    await _controller.dispose();
    _cameraIndex = (_cameraIndex + 1) % cameras.length;
    await _initializeCamera(_cameraIndex);
  }

  List<Pose> _poses = [];

  Future<void> _processCameraImage(CameraImage image) async {
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      final poses = await _poseDetector.processImage(inputImage);

      setState(() {
        _poses = poses;
      });

      for (final pose in poses) {
        final leftWrist = pose.landmarks[PoseLandmarkType.leftWrist];
        debugPrint('Left wrist position: ${leftWrist?.x}, ${leftWrist?.y}');
      }
    } catch (e) {
      debugPrint('Pose detection error: $e');
    }

    _isProcessing = false;
  }

  InputImage _convertCameraImage(CameraImage image) {
    final WriteBuffer allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation0deg,
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _poseTimer?.cancel();
    _controller.dispose();
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!_isCameraInitialized)
            const Center(child: CircularProgressIndicator())
          else
            Center(child: CameraPreview(_controller)),

          // Add painter overlay
          if (_isCameraInitialized)
            LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                final imageSize = Size(
                  _controller.value.previewSize!.height, // note the flip
                  _controller.value.previewSize!.width,
                );

                return CustomPaint(
                  size: screenSize,
                  painter: PosePainter(
                    poses: _poses,
                    imageSize: imageSize,
                    screenSize: screenSize,
                  ),
                );
              },
            ),

          Positioned(
            bottom: 32,
            right: MediaQuery.of(context).size.width / 2 - 25,
            child: FloatingActionButton(
              onPressed: _flipCamera,
              child: const Icon(Icons.cameraswitch),
            ),
          ),
        ],
      ),
    );
  }
}

class PosePainter extends CustomPainter {
  final List<Pose> poses;
  final Size imageSize;
  final Size screenSize;

  PosePainter({
    required this.poses,
    required this.imageSize,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final highlightPaint =
        Paint()
          ..color = Colors.greenAccent
          ..strokeWidth = 6
          ..style = PaintingStyle.fill;

    final linePaint =
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

    final centerX = screenSize.width / 2;
    final centerY = screenSize.height / 2;

    for (final pose in poses) {
      final landmarks = List<PoseLandmark?>.filled(
        PoseLandmarkType.values.length,
        null,
      );
      pose.landmarks.forEach((type, landmark) {
        landmarks[type.index] = landmark;
      });

      final connections = [
        // Example of body parts to connect with lines:
        [11, 13], // Left Shoulder -> Left Elbow
        [13, 15], // Left Elbow -> Left Wrist
        [12, 14], // Right Shoulder -> Right Elbow
        [14, 16], // Right Elbow -> Right Wrist
        [11, 12], // Left Shoulder -> Right Shoulder
        [12, 24],
        [11, 23],
        [23, 25], // Left Hip -> Left Knee
        [25, 27], // Left Knee -> Left Ankle
        [24, 26], // Right Hip -> Right Knee
        [26, 28], // Right Knee -> Right Ankle
        // Add any other lines you wish to draw
      ];

      for (final pair in connections) {
        final start = landmarks[pair[0]];
        final end = landmarks[pair[1]];
        if (start != null && end != null) {
          double startX = (start.x / imageSize.width) * screenSize.width;
          double startY = (start.y / imageSize.height) * screenSize.height;

          double endX = (end.x / imageSize.width) * screenSize.width;
          double endY = (end.y / imageSize.height) * screenSize.height;

          // Apply rotation
          final dxStart = startX - centerX;
          final dyStart = startY - centerY;
          final rotatedStartX = -dyStart + centerX - 100;
          final rotatedStartY = dxStart + centerY - 80;

          final dxEnd = endX - centerX;
          final dyEnd = endY - centerY;
          final rotatedEndX = -dyEnd + centerX - 100;
          final rotatedEndY = dxEnd + centerY - 80;

          // Draw the line
          canvas.drawLine(
            Offset(rotatedStartX, rotatedStartY),
            Offset(rotatedEndX, rotatedEndY),
            linePaint,
          );
        }
      }

      // Now, draw the individual points
      for (final pose in poses) {
        final landmarks = List<PoseLandmark?>.filled(
          PoseLandmarkType.values.length,
          null,
        );
        pose.landmarks.forEach((type, landmark) {
          landmarks[type.index] = landmark;
        });

        for (int index = 11; index < 29; index++) {
          final landmark = landmarks[index];
          if (landmark == null) continue;

          double x = (landmark.x / imageSize.width) * screenSize.width;
          double y = (landmark.y / imageSize.height) * screenSize.height;

          final dx = x - centerX;
          final dy = y - centerY;

          final rotatedX = -dy + centerX - 100;
          final rotatedY = dx + centerY - 80;

          canvas.drawCircle(Offset(rotatedX, rotatedY), 8, highlightPaint);

          final textPainter = TextPainter(
            text: TextSpan(
              text: '($index)',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          textPainter.paint(canvas, Offset(rotatedX + 6, rotatedY - 14));
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
