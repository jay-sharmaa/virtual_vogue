import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AiResponse extends StatefulWidget {
  final String response;
  const AiResponse({super.key, required this.response});

  @override
  State<AiResponse> createState() => _AiResponseState();
}

class _AiResponseState extends State<AiResponse> {
  String responseText = "";
  TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  late stt.SpeechToText _speech;
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    responseText = widget.response;
    _speech = stt.SpeechToText();
  }

  Future<void> sendRequest() async {
    if (_controller.text.trim().isEmpty) return;

    try {
      var url = Uri.parse("http://10.0.2.2:8080/api/ask");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"question": _controller.text}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        String extractedText = jsonData["candidates"][0]["content"]["parts"][0]["text"];

        setState(() {
          responseText = extractedText;
          _controller.clear();
        });

        Future.delayed(Duration(milliseconds: 100), () {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });
      }
    } catch (e) {
      print("Request failed: $e");
    }
  }

  void startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done") {
          setState(() => isListening = false);
        }
      },
      onError: (errorNotification) {
        setState(() => isListening = false);
        print("Speech recognition error: ${errorNotification.errorMsg},"
            "${errorNotification.toString()}");
      },
    );

    if (available) {
      setState(() => isListening = true);

      // Show acknowledgment message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Listening..."),
          duration: Duration(seconds: 1),
        ),
      );

      _speech.listen(onResult: (result) {
        setState(() {
          _controller.text = result.recognizedWords;
        });
      });
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Speech recognition not available"),
        ),
      );
    }
  }

  void stopListening() {
    _speech.stop();
    setState(() => isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    responseText.isEmpty ? "No response yet" : responseText,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: "Type something..",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                  ),
                ),
                SizedBox(width: 10),

                // Mic/Stop Button
                GestureDetector(
                  onTap: isListening ? stopListening : startListening,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      isListening ? Icons.stop : Icons.mic,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // Send Button
                GestureDetector(
                  onTap: sendRequest,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.send, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
