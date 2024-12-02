import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'api_hourly_weather.dart';
import 'api_model.dart';


class WeatherService {

  final apiKey = 'c32ac327761e471a99d61655242010';

  Future<Weather> getCurrentWeather() async {
    String cityName = await getCurrentCity();
    final url = 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Weather.fromCurrentJson(json);
      } else {
        throw Exception('Failed to load current weather');
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }

  Future<List<Weather>> getNextDaysForecast(int days) async {
    String cityName = await getCurrentCity();

    final url = 'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=$days';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        List<Weather> forecast = [];
        for (var day in json['forecast']['forecastday']) {
          print(day);
          forecast.add(Weather.fromForecastJson(day));
        }
        return forecast;
      } else {
        throw Exception('Failed to load 7-day forecast');
      }
    } catch (error) {
      log('Error: $error');
      return [];
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    String? city = placeMarks[0].locality;
    return city ?? "";
  }
  Future<List<HourlyWeather>> getHourlyForecast() async {
    String cityName = await getCurrentCity();
    final url =
        'http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$cityName&days=1';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<HourlyWeather> hourlyList = (jsonData['forecast']['forecastday'][0]['hour'] as List)
            .map((hourData) => HourlyWeather.fromJson(hourData))
            .toList();
        return hourlyList;
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (error) {
      log('Error: $error');
      return [];
    }
  }



}


