import 'package:agri_easy/screens/chatpage.dart';
import 'package:agri_easy/screens/help-desk.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:agri_easy/screens/homepage.dart';
import 'package:agri_easy/screens/img_upload.dart';
import 'package:agri_easy/screens/chat_screen.dart';
import 'package:agri_easy/screens/home_screen.dart';
import 'package:agri_easy/l10n/app_localizations.dart';
import 'package:agri_easy/screens/products_screen.dart';
import 'package:agri_easy/providers/chats_provider.dart';
import 'package:agri_easy/providers/models_provider.dart';
import 'package:agri_easy/providers/language_provider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:agri_easy/screens/test.dart'; // Import your test.dart screen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'AgriEasy';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => ModelsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: _title,
            locale: languageProvider.locale,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('hi', ''),
              Locale('ta', ''),
            ],
            home: const SplashScreen(), // Splash screen on launch
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyStatefulWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromRGBO(139, 195, 74, 1),
      body: Center(
        child: Text(
          'Welcome to AgriEasy',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int index = 0;
  String? selectedLanguage;

  final screens = [
    const Homepage(),
    const Weather(),
    const ImageUpload(),
    const ChatScreen(),
    const ProductScreen(),
    const ChatPage(),
    //const Help(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = [
      const Icon(Icons.home, size: 30),
      const Icon(Icons.cloud, size: 30),
      const Icon(Icons.camera, size: 30),
      const Icon(Icons.chat, size: 30),
      const Icon(Icons.shopping_cart, size: 30),
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(139, 195, 74, 1),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'test') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Test()),
                  );
                } else {
                  setState(() {
                    selectedLanguage = value;
                  });
                  context.read<LanguageProvider>().setLanguage(value);
                }
              },
              icon: const Icon(
                Icons.language,
                color: Colors.white,
              ),
              color: const Color.fromRGBO(139, 195, 74, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  _buildMenuItem('en', 'English'),
                  const PopupMenuDivider(height: 1),
                  _buildMenuItem('hi', 'हिंदी'),
                  const PopupMenuDivider(height: 1),
                  _buildMenuItem('ta', 'தமிழ்'),
                  const PopupMenuDivider(height: 1),
                  _buildMenuItem('test', 'Go to Test Page'), // New test option
                  const PopupMenuDivider(height: 1),
                  _buildMenuItem('others', 'Others'),
                ];
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        height: 50,
        backgroundColor: Colors.transparent,
        index: index,
        items: items,
        color: const Color.fromARGB(255, 227, 227, 227),
        buttonBackgroundColor: const Color.fromARGB(255, 211, 251, 211),
        onTap: (index) {
          setState(() {
            this.index = index;
          });
        },
      ),
      body: _buildScreen(index),
    );
  }

  PopupMenuEntry<String> _buildMenuItem(String value, String text) {
    bool isSelected = selectedLanguage == value;
    return PopupMenuItem<String>(
      value: value,
      child: Container(
        height: 30,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.transparent,
            width: 1,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        switch (selectedLanguage) {
          case 'hi':
            return const Homepage();
          case 'ta':
            return const Homepage();
          default:
            return const Homepage();
        }
      case 1:
        return const Weather();
      case 2:
        return const HelpDesk();
      case 3:
        return const ChatPage();
      case 4:
        return const ProductScreen();

      default:
        return const SizedBox.shrink();
    }
  }
}
