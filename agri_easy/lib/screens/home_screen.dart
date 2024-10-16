import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:agri_easy/widgets/header_widget.dart';
import 'package:agri_easy/widgets/hourly_data_widget.dart';
import 'package:agri_easy/widgets/daily_data_forecast.dart';
import 'package:agri_easy/controller/global_controller.dart';
import 'package:agri_easy/screens/current_weather_widget.dart';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  // Initialize GlobalController
  final GlobalController globalController =
      Get.put(GlobalController(), permanent: true);

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
          "Weather",
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
        child: Obx(() {
          // Access the RxBool value directly
          final isLoading = globalController.isLoading.value;

          return isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/icons/clouds.png",
                          height: 200, width: 200),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
              : Center(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [
                      const SizedBox(height: 20),
                      const HeaderWidget(),
                      // For current temperature
                      CurrentWeatherWidget(
                        weatherDataCurrent: globalController
                            .getWeatherData()
                            .getCurrentWeather(),
                      ),
                      const SizedBox(height: 20),
                      // For hourly temperature
                      HourlyDataWidget(
                        weatherDataHourly: globalController
                            .getWeatherData()
                            .getHourlyWeather(),
                      ),
                      DailyDataForecast(
                        weatherDataDaily:
                            globalController.getWeatherData().getDailyWeather(),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
