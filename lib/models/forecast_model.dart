// model du lieu du bao thoi tiet
class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String description;
  final String icon;
  final String mainCondition;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final int? pop; // xac suat mua (0-100%)

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    this.pop,
  });

  // parse tu JSON
  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temperature: (json['main']['temp'] as num).toDouble(),
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      mainCondition: json['weather'][0]['main'] as String,
      tempMin: (json['main']['temp_min'] as num).toDouble(),
      tempMax: (json['main']['temp_max'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pop: json['pop'] != null ? ((json['pop'] as num) * 100).round() : null,
    );
  }
}
