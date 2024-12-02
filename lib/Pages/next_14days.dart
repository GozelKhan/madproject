import 'package:flutter/material.dart';
import '../Api/api_model.dart';
import '../Api/api_service.dart';

class Next14days extends StatefulWidget {
  const Next14days({super.key});

  @override
  State<Next14days> createState() => _Next14daysState();
}

class _Next14daysState extends State<Next14days> {

  List<Weather> forecastList = [];


  @override
  void initState() {
    super.initState();
    _loadForecast();
  }

  Future<void> _loadForecast() async {
    List<Weather> forecast = await WeatherService().getNextDaysForecast(14);
    setState(() {
      forecastList = forecast;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff343434),
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: (){Navigator.pop(context);},),
        backgroundColor: const Color(0xff343434),
        title: const Text('14-Day Forecast', style: TextStyle(color: Colors.white),),
      ),

      body: forecastList.isNotEmpty
          ? ListView.builder(
        itemCount: forecastList.length,
        itemBuilder: (context, index) {
          Weather forecast = forecastList[index];
          return ListTile(
            leading: Image.network(
              forecast.icon,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
            title: Text('${forecast.temperature}°C', style: const TextStyle(color: Colors.white),),
            subtitle: Text("${forecast.description} • ${forecast.dateTime}", style: const TextStyle(color: Colors.white),),
          );
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
