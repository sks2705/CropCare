import 'package:flutter/material.dart';
import 'package:agri_easy/utils/custom_colors.dart';
import 'package:agri_easy/model/weather_data_current.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final WeatherDataCurrent weatherDataCurrent;

  const CurrentWeatherWidget({super.key, required this.weatherDataCurrent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero, // Remove padding
      margin: EdgeInsets.zero, // Remove margin
      child: Column(
        children: [
          // For the temperature
          temperatureAreaWidget(),
          const SizedBox(height: 20),
          // More details - humidity, wind speed, clouds
          currentWeatherMoreDetailsWidget(),
        ],
      ),
    );
  }

  Widget currentWeatherMoreDetailsWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(left: 50, right: 50)),
                Image.asset("assets/icons/humidity.png", height: 30, width: 30),
                Text(
                  "${weatherDataCurrent.current.humidity}%",
                  style: const TextStyle(
                    color: CustomColors.textColorBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 1,
              color: CustomColors.dividerLine,
            ),
            Column(
              children: [
                Image.asset("assets/icons/windspeed.png",
                    height: 30, width: 30),
                Text(
                  "${weatherDataCurrent.current.windSpeed} km/h",
                  style: const TextStyle(
                    color: CustomColors.textColorBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 1,
              color: CustomColors.dividerLine,
            ),
            Column(
              children: [
                const Padding(padding: EdgeInsets.only(left: 50, right: 50)),
                Image.asset("assets/icons/clouds.png", height: 30, width: 30),
                Text(
                  "${weatherDataCurrent.current.clouds}%",
                  style: const TextStyle(
                    color: CustomColors.textColorBlack,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget temperatureAreaWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image.asset(
          "assets/weather/${weatherDataCurrent.current.weather![0].icon}.png",
          height: 80,
          width: 80,
        ),
        Container(
          height: 50,
          width: 1,
          color: CustomColors.dividerLine,
        ),
        RichText(
          text: TextSpan(children: [
            TextSpan(
                text: "${weatherDataCurrent.current.temp!.toInt()}°",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 60,
                  color: CustomColors.textColorBlack,
                )),
            TextSpan(
                text: " ${weatherDataCurrent.current.weather![0].description}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey,
                )),
          ]),
        ),
      ],
    );
  }
}
