import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({required this.text, required this.isUser, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();
}

class GeminiChatPage extends StatefulWidget {
  const GeminiChatPage({Key? key}) : super(key: key);

  @override
  _GeminiChatPageState createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage> {
  final TextEditingController _promptController = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = false;
  
  // API URL with key
  final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyD-eVhwXXfJd6p7cgS9cK7TRqagwX3lMJE';

  Future<void> sendMessage() async {
    final String promptText = _promptController.text.trim();
    if (promptText.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(Message(text: promptText, isUser: true));
      _isLoading = true;
      _promptController.clear();
    });

    final headers = {
      "Content-Type": "application/json",
    };
    
    final data = {
      "contents": [
        {
          "parts": [
            {
              "text": promptText
            }
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        final responseText = decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        
        setState(() {
          _messages.add(Message(text: responseText, isUser: false));
          _isLoading = false;
        });
      } else {
        setState(() {
          _messages.add(Message(
            text: 'Error: ${response.statusCode}\n${response.body}',
            isUser: false,
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(Message(text: 'Exception: $e', isUser: false));
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: Row(
              children: [
                // API Responses (Left)
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        if (!message.isUser) {
                          return _buildMessageBubble(message);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
                // Vertical Divider
                Container(width: 1, color: Colors.grey[300]),
                // User Prompts (Right)
                Expanded(
                  child: Container(
                    color: Colors.blue[50],
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        if (message.isUser) {
                          return _buildMessageBubble(message);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Loading indicator
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Gemini is thinking...', 
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
          // Message input
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: sendMessage,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  elevation: 2,
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.isUser;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              backgroundColor: Colors.blue[700],
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 16),
              radius: 16,
            ),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? Colors.blue[600] : Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.1),
                  )
                ],
              ),
              child: SelectableText(
                message.text,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
          if (isUser)
            CircleAvatar(
              backgroundColor: Colors.grey[800],
              radius: 16,
              child: const Icon(Icons.person, color: Colors.white, size: 16),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}