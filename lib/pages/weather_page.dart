import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/custom_button.dart';
import 'package:flutter_app/pages/prelander_page.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/weather_model.dart';
import '../services/auth_service.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override 
  State<WeatherPage> createState() => _WeatherPageSlice();
}

class _WeatherPageSlice extends State<WeatherPage> {
  WeatherService? _weatherService;
  Weather? weather;
  bool isLoading = true;
//fetch weather
  _fetchWeather() async {
    //get currentCity
    String cityName = await _weatherService!.getCurrentCity();

    // Get weather for the city
    final weatherResponse = await _weatherService!.getWeather(cityName);
    setState(() {
      weather = weatherResponse;
      isLoading = false;
    });
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'dust':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  double kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  void logout() async {
    final auth = AuthService();
    try {
      await auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PrelanderPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

//init state
  @override
  void initState() {
    super.initState();

    final apiKey = dotenv.env["API_KEY"];
    _weatherService = WeatherService(apiKey ?? "");

    if (_weatherService != null) {
      _fetchWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const AlignmentDirectional(3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.deepPurple),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-3, -0.3),
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFF673AB7)),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, -1.2),
                  child: Container(
                    height: 300,
                    width: 600,
                    decoration: const BoxDecoration(color: Color(0xFFFFAB40)),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLoading) ...[
                          const SizedBox(height: 400),
                          const Center(
                              child:
                                  CircularProgressIndicator()), 
                        ] else ...[
                          Text(
                            "📍${weather?.cityName ?? "Loading city..."}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 100),
                          Center(
                              child: Lottie.asset(
                                  getWeatherAnimation(weather?.mainCondition))),
                          Center(
                              child: Text(
                            weather?.mainCondition ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          )),
                          Center(
                              child: Text(
                            '${kelvinToCelsius(weather?.temperature.toDouble() ?? 0.0).toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 55,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
                          const SizedBox(height: 50),
                          Center(
                            child: CustomButton(text: "Sign Out", onTap: logout),
                          ),
                        ],
                      ]),
                )
              ],
            ),
          ),
        ));
  }
}
