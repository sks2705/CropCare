import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:agri_easy/controller/global_controller.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({super.key});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String city = "Loading...";
  String date = DateFormat("yMMMMd").format(DateTime.now());

  final GlobalController globalController = Get.find<GlobalController>();

  @override
  void initState() {
    super.initState();
    // Delay to ensure GlobalController is fully initialized
    Future.delayed(Duration.zero, () {
      _fetchAddress();
    });
  }

  Future<void> _fetchAddress() async {
    try {
      // Check if latitude and longitude are initialized and valid
      final lat = globalController.latitude.value;
      final lon = globalController.longitude.value;

      if (lat == 0.0 || lon == 0.0) {
        setState(() {
          city = "Location not available";
        });
        return;
      }

      // Fetch address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        setState(() {
          city = place.locality ?? "Unknown location";
        });
      } else {
        setState(() {
          city = "No placemark found";
        });
      }
    } catch (e) {
      print('Error fetching location: $e'); // Log error for debugging
      setState(() {
        city = "Error fetching location";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.topLeft,
          child: Text(
            city,
            style: const TextStyle(
              fontSize: 34,
              height: 2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          alignment: Alignment.topLeft,
          child: Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
