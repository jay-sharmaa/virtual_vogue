import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:flutter_cube/flutter_cube.dart';

class TryPage extends StatefulWidget {
  final String name;
  const TryPage({super.key, required this.name});

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

  String fileName = "assets/shirt.obj";
  bool isPants = false;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );
    if (widget.name == "assets/mens_jeans.png") {
      fileName = "assets/pants.obj";
      isPants = true;
    }
    _initEverything();
    print(widget.name);
  }

  Future<void> _initEverything() async {
    try {
      cameras = await availableCameras();
      await _initializeCamera(_cameraIndex);
      configueObj();
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

  List<Pose> _poses = [];

  Future<void> _processCameraImage(CameraImage image) async {
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image);
      final poses = await _poseDetector.processImage(inputImage);

      setState(() {
        _poses = poses;
      });

      _checkDirectionAndRotate();
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

  int angle = 30;
  late Object _object;

  void _rotateObject(double angle) {
    setState(() {
      _object.rotation.z = 0;
      _object.rotation.x = 0;
      _object.rotation.y = angle;
      _object.updateTransform();
    });
  }

  void _rotateObjectRight(double angle) {
    setState(() {
      _object.rotation.z = 0;
      _object.rotation.x = 0;
      _object.rotation.y += angle;
      _object.updateTransform();
    });
  }

  void configueObj() {
    setState(() {
      _object.rotation.x = 0;
      _object.rotation.y = 0;
      _object.updateTransform();
    });
  }

  void _checkDirectionAndRotate() {
    for (final pose in _poses) {
      final landmarks = List<PoseLandmark?>.filled(
        PoseLandmarkType.values.length,
        null,
      );
      pose.landmarks.forEach((type, landmark) {
        landmarks[type.index] = landmark;
      });

      // === Shoulder Angle Logic ===
      final leftShoulder = landmarks[11];
      final rightShoulder = landmarks[12];
      final rightHip = landmarks[24];
      final rightKnee = landmarks[26];
      final rightAnkle = landmarks[28];

      if (leftShoulder != null && rightShoulder != null) {
        final dx = rightShoulder.x - leftShoulder.x;
        final dy = rightShoulder.y - leftShoulder.y;
        final angleRad = atan2(dy, dx);
        final angleDeg = angleRad * (180 / pi);
        final absAngle = angleDeg.abs();
        final angleDelta = angleDeg - 85;

        print("Angle: $angleDeg");

        if (absAngle >= 85 && absAngle <= 95) {
          print("Facing forward");
          _rotateObject(angleDelta);
        } else if (absAngle > 65 && absAngle < 85) {
          print("Turning right");
          _rotateObject(angleDelta);
        } else if (absAngle > 95 && absAngle < 110) {
          print("Turning left");
          _rotateObject(angleDelta);
        }
      }

      // === Scale Object based on item type ===
      if (isPants) {
        // For pants, use leg position only (hip to ankle)
        if (rightHip != null && rightAnkle != null) {
          // final dx = rightHip.x - rightAnkle.x;
          // final dy = rightHip.y - rightAnkle.y;
          // final dz = rightHip.z - rightAnkle.z;
          // final legLength = sqrt(dx * dx + dy * dy + dz * dz);

          // Skip scaling
          _updatePantsPosition(rightHip, rightAnkle);
        }
      } else {
        // For shirts, use torso length (shoulder to hip)
        if (rightShoulder != null && rightHip != null) {
          final dx = rightShoulder.x - rightHip.x;
          final dy = rightShoulder.y - rightHip.y;
          final dz = rightShoulder.z - rightHip.z;
          final torsoLength = sqrt(dx * dx + dy * dy + dz * dz);

          print("Shoulder-to-Hip height: $torsoLength");
          _scaleObject(torsoLength);

          // Position the shirt using shoulder and hip
          _updateShirtPosition(rightShoulder, rightHip);
        }
      }
    }
  }

  void _scaleObject(double bodyPartLength) {
    // Use the same multiplication factor for both shirt and pants
    final normalizedScale =
        bodyPartLength * 0.03; // Adjust multiplier as needed

    setState(() {
      _object.scale.setValues(
        normalizedScale,
        normalizedScale,
        normalizedScale,
      );
      _object.updateTransform();
    });
  }

  void _updateShirtPosition(PoseLandmark shoulder, PoseLandmark hip) {
    final midX = (shoulder.x + hip.x) / 2 - 100;
    final midY = (shoulder.y + hip.y) / 2;
    final midZ = (shoulder.z + hip.z) / 2 - 20;

    setState(() {
      _object.position.setValues(
        (midX - 180) * 0.02,
        -(midY - 320) * 0.02,
        -midZ * 0.1,
      );
      _object.updateTransform();
    });
  }

  void _updatePantsPosition(PoseLandmark hip, PoseLandmark ankle) {
    final midX = (hip.x + ankle.x) / 2 - 100;
    final midY = (hip.y + ankle.y) / 2;
    final midZ = (hip.z + ankle.z) / 2 - 20;

    setState(() {
      _object.position.setValues(
        (midX - 180) * 0.02,
        -(midY - 320) * 0.02,
        -midZ * 0.1,
      );
      _object.updateTransform();
    });
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

          if (_isCameraInitialized)
            LayoutBuilder(
              builder: (context, constraints) {
                final screenSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                final imageSize = Size(
                  _controller.value.previewSize!.height,
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

          Cube(
            onSceneCreated: (Scene scene) {
              scene.world.add(
                _object = Object(
                  scale: Vector3.all(5.0),
                  rotation: Vector3(angle.toDouble(), 0, 0),
                  position: Vector3(0, 0, 0),
                  fileName: fileName,
                ),
              );
            },
          ),
          Positioned(
            bottom: 32,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _rotateObjectRight(10);
              },
              child: const Icon(Icons.arrow_right),
            ),
          ),

          Positioned(
            bottom: 32,
            right: 325,
            child: FloatingActionButton(
              onPressed: () {
                _rotateObjectRight(-10);
              },
              child: const Icon(Icons.arrow_left),
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

      // === Draw bones/lines ===
      final connections = [
        [11, 13], [13, 15], // Left shoulder -> elbow -> wrist
        [12, 14], [14, 16], // Right shoulder -> elbow -> wrist
        [11, 12], // Left shoulder -> Right shoulder
        [12, 24], [11, 23], // Right shoulder -> Hip -> Left hip
        [23, 25], [25, 27], // Left Hip -> Knee -> Ankle
        [24, 26], [26, 28], // Right Hip -> Knee -> Ankle
      ];

      for (final pair in connections) {
        final start = landmarks[pair[0]];
        final end = landmarks[pair[1]];
        if (start != null && end != null) {
          double startX = (start.x / imageSize.width) * screenSize.width;
          double startY = (start.y / imageSize.height) * screenSize.height;
          double endX = (end.x / imageSize.width) * screenSize.width;
          double endY = (end.y / imageSize.height) * screenSize.height;

          final dxStart = startX - centerX;
          final dyStart = startY - centerY;
          final rotatedStartX = -dyStart + centerX - 100;
          final rotatedStartY = dxStart + centerY - 80;

          final dxEnd = endX - centerX;
          final dyEnd = endY - centerY;
          final rotatedEndX = -dyEnd + centerX - 100;
          final rotatedEndY = dxEnd + centerY - 80;

          canvas.drawLine(
            Offset(rotatedStartX, rotatedStartY),
            Offset(rotatedEndX, rotatedEndY),
            linePaint,
          );
        }
      }

      // === Draw points ===
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
