import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:agri_easy/api/fetch_weather.dart';
import 'package:agri_easy/model/weather_data.dart';

class GlobalController extends GetxController {
  // Variables for managing state
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  // Observable properties
  RxBool get isLoading => _isLoading;
  RxDouble get latitude => _latitude;
  RxDouble get longitude => _longitude;
  RxInt get currentIndex => _currentIndex;

  final Rx<WeatherData> weatherData = WeatherData().obs;

  WeatherData getWeatherData() {
    return weatherData.value;
  }

  @override
  void onInit() {
    getLocation(); // Call getLocation method directly
    super.onInit();
  }

  Future<void> getLocation() async {
    bool isServiceEnabled;
    LocationPermission locationPermission;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      _isLoading.value = false;
      return Future.error('Location services are disabled.');
    }

    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      _isLoading.value = false;
      return Future.error('Location permissions are denied forever.');
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.deniedForever) {
        _isLoading.value = false;
        return Future.error('Location permissions are denied forever.');
      } else if (locationPermission == LocationPermission.denied) {
        _isLoading.value = false;
        return Future.error('Location permissions are denied.');
      }
    }

    // Getting the position of the user
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _latitude.value = position.latitude;
      _longitude.value = position.longitude;

      // Fetching weather data
      final weather = await FetchWeatherAPI()
          .processData(position.latitude, position.longitude);
      weatherData.value = weather;
      _isLoading.value = false;
    } catch (e) {
      _isLoading.value = false;
      return Future.error('Failed to get location or weather data: $e');
    }
  }

  void setIndex(int index) {
    _currentIndex.value = index;
  }
}
