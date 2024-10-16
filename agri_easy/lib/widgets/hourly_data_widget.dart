import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:agri_easy/utils/custom_colors.dart';
import 'package:agri_easy/model/weather_data_hourly.dart';
import 'package:agri_easy/controller/global_controller.dart';

class HourlyDataWidget extends StatelessWidget {
  final WeatherDataHourly weatherDataHourly;

  const HourlyDataWidget({super.key, required this.weatherDataHourly});

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.find<GlobalController>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          alignment: Alignment.topCenter,
          child: const Text("Today", style: TextStyle(fontSize: 20)),
        ),
        hourlyList(globalController),
      ],
    );
  }

  Widget hourlyList(GlobalController globalController) {
    return Container(
      height: 160,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly.hourly.length > 12
            ? 12
            : weatherDataHourly.hourly.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final cardIndex = globalController.currentIndex.value;
            return GestureDetector(
              onTap: () {
                globalController.setIndex(index);
              },
              child: Container(
                width: 90,
                margin: const EdgeInsets.only(left: 20, right: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0.5, 0),
                      blurRadius: 30,
                      spreadRadius: 1,
                      color: CustomColors.dividerLine.withAlpha(150),
                    )
                  ],
                  gradient: cardIndex == index
                      ? const LinearGradient(
                          colors: [
                            CustomColors.firstGradientColor,
                            CustomColors.secondGradientColor,
                          ],
                        )
                      : null,
                ),
                child: HourlyDetails(
                  cardIndex: cardIndex,
                  index: index,
                  temp: weatherDataHourly.hourly[index].temp!,
                  timeStamp: weatherDataHourly.hourly[index].dt!,
                  weatherIcon:
                      weatherDataHourly.hourly[index].weather![0].icon!,
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class HourlyDetails extends StatelessWidget {
  final int temp;
  final int timeStamp;
  final int index;
  final int cardIndex;
  final String weatherIcon;

  const HourlyDetails({
    super.key,
    required this.cardIndex,
    required this.index,
    required this.timeStamp,
    required this.temp,
    required this.weatherIcon,
  });

  String getTime(final timestamp) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat("jm").format(time);
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = cardIndex == index;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTime(timeStamp),
            style: TextStyle(
              color: isSelected ? Colors.white : CustomColors.textColorBlack,
            ),
          ),
        ),
        Container(
          child: Image.asset(
            "assets/weather/$weatherIcon.png",
            height: 40,
            width: 40,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            "$temp°",
            style: TextStyle(
              color: isSelected ? Colors.white : CustomColors.textColorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
