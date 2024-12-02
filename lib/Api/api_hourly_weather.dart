class HourlyWeather {
  final double temperature;
  final String description;
  final String time;
  final String iconUrl;

  HourlyWeather({
    required this.temperature,
    required this.description,
    required this.time,
    required this.iconUrl,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      temperature: json['temp_c'].toDouble(),
      description: json['condition']['text'],
      time: json['time'],
      iconUrl: 'https:${json['condition']['icon']}',
    );
  }
}
