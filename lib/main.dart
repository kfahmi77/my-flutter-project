import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.rubikTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: false,
      ),
      home: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage("Halo! Saya adalah asisten AI. Ada yang bisa saya bantu?");
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teks disalin ke clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() {
      _messages.insert(0, Message(text: text, isUser: true));
      _isTyping = true;
    });
    _scrollToBottom();
    String response = await _getBotResponse(text);
    setState(() {
      _isTyping = false;
      _messages.insert(0, Message(text: response, isUser: false));
    });
    _scrollToBottom();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.insert(0, Message(text: text, isUser: false));
    });
  }

  Future<String> _getBotResponse(String text) async {
    final encodedText = Uri.encodeComponent(text);
    final url =
        Uri.parse('https://api.nyxs.pw/ai/gemini-advance?text=$encodedText');
    try {
      final response = await http.get(
        url,
        headers: {'accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['result'];
      } else {
        return 'Maaf, saya mengalami masalah dalam memproses permintaan Anda.';
      }
    } catch (e) {
      return 'Terjadi kesalahan: $e';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
              ),
              child: ListView.builder(
                reverse: true,
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ChatMessage(
                    message: _messages[index],
                   onLongPress: () => _copyToClipboard(_messages[index].text)
                  );
                },
              ),
            ),
          ),
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.transparent,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("AI sedang mengetik",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(width: 8),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: const InputDecoration(
                hintText: 'Ketik pesan...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;
  final VoidCallback onLongPress;

  ChatMessage({required this.message, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.android, color: Colors.white),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: onLongPress,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (message.isUser)
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[700]),
            ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}
