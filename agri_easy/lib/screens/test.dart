import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:agri_easy/widgets/header_widget.dart';
// import 'package:agri_easy/widgets/hourly_data_widget.dart';
// import 'package:agri_easy/widgets/daily_data_forecast.dart';
import 'package:agri_easy/controller/global_controller.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // Go back to the previous screen
            },
          ),
        ],
      ),

      //ADD your code
      body: const Center(
        child: Text(
          'Welcome to AgriEasy',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      //ADD your code
    );
  }
}
