import 'dart:developer';
import '../widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/models_provider.dart';
import 'package:agri_easy/widgets/chat_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agri_easy/providers/chats_provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;
  bool _isMicActive = false; // State to track mic activation

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;
  late stt.SpeechToText _speechToText; // Speech to Text instance

  @override
  void initState() {
    super.initState();
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    _speechToText = stt.SpeechToText(); // Initialize the SpeechToText instance
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    if (_isMicActive) {
      _speechToText.stop(); // Stop listening if active
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

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
          padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex,
                    shouldAnimate: chatProvider.getChatList.length - 1 == index,
                  );
                },
              ),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Color.fromARGB(255, 0, 0, 0),
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: const Color.fromARGB(255, 1, 110, 10),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                          );
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration.collapsed(
                          hintText: 'How can I help you',
                          hintStyle: TextStyle(
                            fontFamily: "Lobster",
                            color: Color.fromARGB(255, 201, 201, 201),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await sendMessageFCT(
                          modelsProvider: modelsProvider,
                          chatProvider: chatProvider,
                        );
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        setState(() {
                          _isMicActive = !_isMicActive; // Toggle mic state
                        });
                        if (_isMicActive) {
                          bool available = await _speechToText.initialize();
                          if (available) {
                            _speechToText.listen(
                              onResult: (result) {
                                setState(() {
                                  textEditingController.text =
                                      result.recognizedWords;
                                });
                              },
                              listenFor: const Duration(
                                  seconds: 5), // Adjusted duration
                              pauseFor: const Duration(seconds: 1),
                              partialResults: true,
                              onSoundLevelChange: (double level) {
                                // Optionally handle sound level changes
                              },
                            );
                          } else {
                            setState(() {
                              _isMicActive =
                                  false; // Turn off mic if initialization fails
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: TextWidget(
                                  label: "Speech recognition not available",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          _speechToText.stop();
                        }
                      },
                      icon: Icon(
                        Icons.mic,
                        color: _isMicActive
                            ? Colors.red
                            : Colors.green, // Toggle color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(
      _listScrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.easeOut,
    );
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You can't send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
        msg: msg,
        chosenModelId: modelsProvider.getCurrentModel,
      );
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: TextWidget(
            label: error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }
}
