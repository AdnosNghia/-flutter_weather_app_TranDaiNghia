import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // URL goc cua OpenWeatherMap API
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String iconBaseUrl = 'https://openweathermap.org/img/wn';

  // endpoint
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';

  // lay api key tu file .env
  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  // tao URL day du voi cac tham so
  static String buildUrl(
    String endpoint,
    Map<String, String> params, {
    String lang = 'vi',
  }) {
    params['appid'] = apiKey;
    params['units'] = 'metric'; // dung do C
    params['lang'] = lang; // ngon ngu tra ve (vi, en,...)
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    return uri.toString();
  }

  // lay URL icon thoi tiet
  static String getIconUrl(String iconCode, {int size = 2}) {
    return '$iconBaseUrl/$iconCode@${size}x.png';
  }
}
