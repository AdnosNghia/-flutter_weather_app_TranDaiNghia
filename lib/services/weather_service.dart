import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  // lay thoi tiet hien tai theo ten thanh pho
  Future<WeatherModel> getCurrentWeatherByCity(
    String cityName, {
    String lang = 'vi',
  }) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {
      'q': cityName,
    }, lang: lang);

    print('Goi API: $url'); // debug

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Không tìm thấy thành phố');
      } else if (response.statusCode == 401) {
        throw Exception('Khóa API không hợp lệ');
      } else if (response.statusCode == 429) {
        throw Exception('Đã vượt quá giới hạn API');
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Lỗi kết nối mạng. Vui lòng kiểm tra internet.');
      }
      rethrow;
    }
  }

  // lay thoi tiet theo toa do GPS
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon, {
    String lang = 'vi',
  }) async {
    final url = ApiConfig.buildUrl(ApiConfig.currentWeather, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    }, lang: lang);

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Không thể tải dữ liệu thời tiết');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Lỗi kết nối mạng. Vui lòng kiểm tra internet.');
      }
      rethrow;
    }
  }

  // lay du bao 5 ngay theo ten thanh pho
  Future<List<ForecastModel>> getForecast(
    String cityName, {
    String lang = 'vi',
  }) async {
    final url = ApiConfig.buildUrl(ApiConfig.forecast, {
      'q': cityName,
    }, lang: lang);

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((item) => ForecastModel.fromJson(item)).toList();
      } else {
        throw Exception('Không thể tải dữ liệu dự báo');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Lỗi kết nối mạng. Vui lòng kiểm tra internet.');
      }
      rethrow;
    }
  }

  // lay du bao theo toa do
  Future<List<ForecastModel>> getForecastByCoordinates(
    double lat,
    double lon, {
    String lang = 'vi',
  }) async {
    final url = ApiConfig.buildUrl(ApiConfig.forecast, {
      'lat': lat.toString(),
      'lon': lon.toString(),
    }, lang: lang);

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['list'];
        return list.map((item) => ForecastModel.fromJson(item)).toList();
      } else {
        throw Exception('Không thể tải dữ liệu dự báo');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') ||
          e.toString().contains('TimeoutException')) {
        throw Exception('Lỗi kết nối mạng. Vui lòng kiểm tra internet.');
      }
      rethrow;
    }
  }
}
