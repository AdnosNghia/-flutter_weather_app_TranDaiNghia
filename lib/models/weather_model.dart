// model du lieu thoi tiet hien tai
class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final String description;
  final String icon;
  final String mainCondition;
  final DateTime dateTime;
  final double? tempMin;
  final double? tempMax;
  final int? visibility;
  final int? cloudiness;
  final DateTime? sunrise;
  final DateTime? sunset;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.description,
    required this.icon,
    required this.mainCondition,
    required this.dateTime,
    this.tempMin,
    this.tempMax,
    this.visibility,
    this.cloudiness,
    this.sunrise,
    this.sunset,
  });

  // parse tu JSON response cua API
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      country: json['sys']?['country'] ?? '',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      description: json['weather'][0]['description'] as String,
      icon: json['weather'][0]['icon'] as String,
      mainCondition: json['weather'][0]['main'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      tempMin: (json['main']['temp_min'] as num?)?.toDouble(),
      tempMax: (json['main']['temp_max'] as num?)?.toDouble(),
      visibility: json['visibility'] as int?,
      cloudiness: json['clouds']?['all'] as int?,
      sunrise: json['sys']?['sunrise'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['sys']['sunrise'] as int) * 1000,
            )
          : null,
      sunset: json['sys']?['sunset'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (json['sys']['sunset'] as int) * 1000,
            )
          : null,
    );
  }

  // chuyen sang JSON de luu cache
  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'sys': {
        'country': country,
        'sunrise': sunrise?.millisecondsSinceEpoch != null
            ? sunrise!.millisecondsSinceEpoch ~/ 1000
            : null,
        'sunset': sunset?.millisecondsSinceEpoch != null
            ? sunset!.millisecondsSinceEpoch ~/ 1000
            : null,
      },
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
        'temp_min': tempMin,
        'temp_max': tempMax,
      },
      'wind': {'speed': windSpeed},
      'weather': [
        {'description': description, 'icon': icon, 'main': mainCondition},
      ],
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'visibility': visibility,
      'clouds': {'all': cloudiness},
    };
  }
}
