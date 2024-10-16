// chatpage.dart
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final WebViewController _controller; // Declare the controller

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Allow JavaScript
      ..loadRequest(
        Uri.parse(
            'https://www.chatbase.co/chatbot-iframe/ZxsDNqj-4Kj9hTbAHrpht'), // Load a webpage
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Color.fromARGB(255, 0, 100, 3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: const Text(
          "AgriBot",
          style: TextStyle(
            fontFamily: "Lobster",
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 0, bottom: 4, left: 4),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SafeArea(
        // Ensures that content does not overlap system UI
        child: WebViewWidget(
            controller: _controller), // Display the WebView full-screen
      ),
    );
  }
}
