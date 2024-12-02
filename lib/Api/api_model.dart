class Weather {
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String dateTime;
  final String icon;



  Weather(  {
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.dateTime,
    required this.icon,
  });

  factory Weather.fromCurrentJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['current']['temp_c'].toDouble(),
      description: json['current']['condition']['text'],
      humidity: json['current']['humidity'],
      windSpeed: json['current']['wind_kph'].toDouble(),
      dateTime: json['location']['localtime'],
      icon: 'https:${json['current']['condition']['icon']}',
    );
  }

  factory Weather.fromForecastJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['day']['avgtemp_c'].toDouble(),
      description: json['day']['condition']['text'],
      humidity: json['day']['avghumidity'],
      windSpeed: json['day']['maxwind_kph'].toDouble(),
      dateTime: json['date'],
      icon: 'https:${json['day']['condition']['icon']}',
    );
  }
}
