import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:virtualvogue/toast.dart';

class SequentialTextPage extends StatefulWidget {
  const SequentialTextPage({Key? key}) : super(key: key);

  @override
  State<SequentialTextPage> createState() => _SequentialTextPageState();
}

class _SequentialTextPageState extends State<SequentialTextPage>
    with TickerProviderStateMixin {
  final List<String> _messages = [
    "Ever looked at someone thought how you would look in their attire?",
    "Now you can see for yourself",
  ];

  int _currentMessageIndex = 0;
  bool _visible = false;
  bool _showCamera = false;
  late AnimationController _animationController;
  late Animation<double> _fadeInOut;
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  int _cameraClickCount = 0;
  late AnimationController _finalMessageController;
  late Animation<double> _finalMessageFadeInOut;
  String? _finalMessage;
  
  // Get toast service instance
  final ToastService _toastService = ToastService();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeInOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _finalMessageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _finalMessageFadeInOut = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _finalMessageController, curve: Curves.easeInOut),
    );

    Timer(const Duration(milliseconds: 300), _startSequence);
  }

  void _startSequence() {
    setState(() {
      _visible = true;
    });
    _animationController.forward();
    _scheduleNextMessage();
  }

  void _scheduleNextMessage() {
    Timer(const Duration(seconds: 3), () {
      _animationController.reverse();
      Timer(const Duration(milliseconds: 500), () {
        setState(() {
          if (_currentMessageIndex < _messages.length - 1) {
            _currentMessageIndex++;
            _animationController.forward();
            _scheduleNextMessage();
          } else {
            _showCamera = true;
            _initializeCamera();
          }
        });
      });
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _cameraController = CameraController(
        _cameras![0],
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {});
    }
  }

  void _onCameraIconPressed() {
    setState(() {
      _cameraClickCount++;
    });

    if (_cameraClickCount == 6) {
      setState(() {
        _finalMessage = "Pictures taken. Wait for some time, you can browse our app till then.";
        _showCamera = false;
      });
      
      _finalMessageController.forward();
      
      _toastService.scheduleToast(
        "Your Try-On is Ready! Check it out now!",
        const Duration(minutes: 2),
      );
      
      Timer(const Duration(seconds: 3), () {
        _finalMessageController.reverse();
        
        Timer(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: _showCamera
                ? _buildCameraView()
                : _finalMessage != null
                    ? FadeTransition(
                        opacity: _finalMessageFadeInOut,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            _finalMessage!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeInOut,
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            _messages[_currentMessageIndex],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
          ),
          
          if (_showCamera)
            Positioned(
              bottom: 20,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 40,
                  ),
                  onPressed: _onCameraIconPressed,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
    return CameraPreview(_cameraController!);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    _finalMessageController.dispose();
    super.dispose();
  }
}

void generatePreviewModel() async {
  final apiKey = 'msy_hhUoeMnzOjD805uMLKQI9MevijZWv3SUg6bU';
  if (apiKey == null) {
    print('MESHY_API_KEY not set.');
    return;
  }

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  final body = jsonEncode({
    "mode": "preview",
    "prompt": "a monster mask",
    "negative_prompt": "low quality, low resolution, low poly, ugly",
    "art_style": "realistic",
    "should_remesh": true,
  });

  final response = await http.post(
    Uri.parse("https://api.meshy.ai/openapi/v2/text-to-3d"),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    final taskId = result["result"];
    print("Preview task created. Task ID: $taskId");
  } else {
    print("Request failed: ${response.statusCode}");
    print(response.body);
  }
}

Future<void> pollPreviewTask(String taskId) async {
  final apiKey = 'msy_hhUoeMnzOjD805uMLKQI9MevijZWv3SUg6bU';
  if (apiKey == null) {
    print('MESHY_API_KEY not set.');
    return;
  }

  final headers = {
    'Authorization': 'Bearer $apiKey',
    'Content-Type': 'application/json',
  };

  while (true) {
    final response = await http.get(
      Uri.parse("https://api.meshy.ai/openapi/v2/text-to-3d/$taskId"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final status = data['status'];
      final progress = data['progress'];

      if (status == "SUCCEEDED") {
        print("Preview task finished.");
        break;
      } else {
        print("Preview task status: $status | Progress: $progress | Retrying in 5 seconds...");
        await Future.delayed(Duration(seconds: 5));
      }
    } else {
      print("Failed to poll task status: ${response.statusCode}");
      print(response.body);
      break;
    }
  }
}


Future<void> downloadPreviewModel(String glbUrl, String savePath) async {
  final response = await http.get(Uri.parse(glbUrl));

  if (response.statusCode == 200) {
    final file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    print("Preview model downloaded to $savePath.");
  } else {
    print("Failed to download model: ${response.statusCode}");
    print(response.body);
  }
}