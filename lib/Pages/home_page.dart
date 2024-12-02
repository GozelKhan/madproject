import 'dart:developer';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:madproject/Api/api_model.dart';
import 'package:madproject/Api/api_service.dart';
import 'package:madproject/Pages/next_14days.dart';
import 'package:madproject/Pages/next_7days.dart';
import '../Api/api_hourly_weather.dart';

class WeatherAppPage extends StatefulWidget {
  const WeatherAppPage({super.key});

  @override
  State<WeatherAppPage> createState() => _WeatherAppPageState();
}

class _WeatherAppPageState extends State<WeatherAppPage> {

  late Weather _weather;
  bool isLoading = false;
  List<HourlyWeather> hourlyWeatherList = [];

  void getWeather() async {
    setState(() {
      isLoading = true;
    });

    Weather? weather = await WeatherService().getCurrentWeather();
    _weather = weather;
    setState(() {
      isLoading = false;
    });
    }

  String getWeatherCondition(String? mainCondition){
    if(mainCondition == null) return 'Assets/Animations/clear.json';

    switch (mainCondition.toLowerCase()){
      case 'clouds':
        return 'Assets/Animations/cloudy.json';

      case 'rain':
        return 'Assets/Animations/rain.json';

      case 'drizzle':
        return 'Assets/Animations/drizzle.json';

      case 'shower rain':
        return 'Assets/Animations/rain.json';

      case 'thunderstorm':
        return 'Assets/Animations/thunderstorm.json';

      case 'clear':
        return 'Assets/Animations/clear.json';

      default:
        return 'Assets/Animations/clear.json';
    }

  }

  Future<void> _loadHourlyForecast() async {
    try {
      List<HourlyWeather> hourly = await WeatherService().getHourlyForecast();
      setState(() {
        hourlyWeatherList = hourly;
      });
    } catch (error) {
      log('Error: $error');
    }
  }


  @override
  void initState() {
    super.initState();
    getWeather();
    _loadHourlyForecast();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343434),
      appBar: AppBar(
        backgroundColor: const Color(0xff343434),
        title: const Text("Weatherly", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),),
        centerTitle: true,
      ),

      body: Column(
        children: [
        const SizedBox(height: 10),
          if(isLoading)
            const CircularProgressIndicator(),

          if(!isLoading)
            ...[
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextButton(
          onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Next7days()));
          },
          style: TextButton.styleFrom(
          side: const BorderSide(color: Colors.white, width: 2.0),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
          ),
          child: const Text("7 Days Forecast", style: TextStyle(color: Colors.white)),
    ),

    const SizedBox(width: 10),

    // 14 Days Forecast Button
    TextButton(
    onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Next14days()));
    },
    style: TextButton.styleFrom(
    side: const BorderSide(color: Colors.white, width: 2.0),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
    ),
    child: const Text("14 Days Forecast", style: TextStyle(color: Colors.white)),
    ),
    ],
    ),
              const SizedBox(height: 30,),

              const Text("Today's Weather", style: TextStyle(color: Colors.white),),
              Text(_weather.dateTime.split(" ")[0], style: const TextStyle(color: Colors.white),),
              Center(child: Lottie.asset(getWeatherCondition(_weather.description), width: 300, height: 300)),
              const SizedBox(height: 20,),
              Text('${_weather.temperature.round()}°C', style: const TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold),),
              Text(_weather.description, style: const TextStyle(fontSize: 24, color: Colors.white),),
            ],

          Expanded(
            child: hourlyWeatherList.isNotEmpty
                ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hourlyWeatherList.length,
              itemBuilder: (context, index) {
                HourlyWeather hourly = hourlyWeatherList[index];
                return SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(hourly.time.substring(11),style: const TextStyle(color: Colors.white),),
                      Image.network(
                        hourly.iconUrl,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                      Text('${hourly.temperature}°C', style: const TextStyle(color: Colors.white),),
                      Text(hourly.description, style: const TextStyle(color: Colors.white),),
                    ],
                  ),
                );
              },
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
