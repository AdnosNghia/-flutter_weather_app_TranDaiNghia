import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../utils/constants.dart';

class StorageService {
  // key luu tru
  static const String _weatherKey = 'cached_weather';
  static const String _forecastKey = 'cached_forecast';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _searchHistoryKey = 'search_history';
  static const String _tempUnitKey = 'temp_unit';
  static const String _windUnitKey = 'wind_unit';
  static const String _timeFormatKey = 'time_format';
  static const String _languageKey = 'language';

  // === Cache thoi tiet ===

  // luu du lieu thoi tiet vao cache
  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
    print('Da luu cache thoi tiet: ${weather.cityName}'); // debug
  }

  // doc du lieu thoi tiet tu cache
  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(_weatherKey);
    if (weatherJson != null) {
      print('Doc cache thoi tiet thanh cong'); // debug
      return WeatherModel.fromJson(json.decode(weatherJson));
    }
    return null;
  }

  // luu du lieu du bao vao cache
  Future<void> saveForecastData(List<ForecastModel> forecasts) async {
    final prefs = await SharedPreferences.getInstance();
    final forecastJson = forecasts
        .map(
          (f) => {
            'dt': f.dateTime.millisecondsSinceEpoch ~/ 1000,
            'main': {
              'temp': f.temperature,
              'temp_min': f.tempMin,
              'temp_max': f.tempMax,
              'humidity': f.humidity,
            },
            'weather': [
              {
                'description': f.description,
                'icon': f.icon,
                'main': f.mainCondition,
              },
            ],
            'wind': {'speed': f.windSpeed},
            'pop': f.pop != null ? f.pop! / 100 : null,
          },
        )
        .toList();
    await prefs.setString(_forecastKey, json.encode(forecastJson));
    print('Da luu cache du bao: ${forecasts.length} muc'); // debug
  }

  // doc du lieu du bao tu cache
  Future<List<ForecastModel>> getCachedForecast() async {
    final prefs = await SharedPreferences.getInstance();
    final forecastJson = prefs.getString(_forecastKey);
    if (forecastJson != null) {
      final List<dynamic> list = json.decode(forecastJson);
      return list.map((item) => ForecastModel.fromJson(item)).toList();
    }
    return [];
  }

  // kiem tra cache con hop le khong (30 phut)
  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate == null) return false;
    final difference = DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return difference < AppConstants.cacheDurationMinutes * 60 * 1000;
  }

  // lay thoi gian cap nhat cuoi cung
  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    if (lastUpdate != null) {
      return DateTime.fromMillisecondsSinceEpoch(lastUpdate);
    }
    return null;
  }

  // xoa cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_weatherKey);
    await prefs.remove(_forecastKey);
    await prefs.remove(_lastUpdateKey);
  }

  // === Thanh pho yeu thich ===

  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }

  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  // === Lich su tim kiem ===

  Future<void> addSearchHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_searchHistoryKey) ?? [];
    history.remove(city); // xoa trung lap
    history.insert(0, city); // them vao dau
    if (history.length > AppConstants.maxSearchHistory) {
      history = history.sublist(0, AppConstants.maxSearchHistory);
    }
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // === Cai dat ===

  Future<void> setTempUnit(bool useFahrenheit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tempUnitKey, useFahrenheit);
  }

  Future<bool> getTempUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tempUnitKey) ?? false; // mac dinh la Celsius
  }

  Future<void> setWindUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_windUnitKey, unit);
  }

  Future<String> getWindUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_windUnitKey) ?? 'm/s';
  }

  Future<void> setTimeFormat(bool use24h) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_timeFormatKey, use24h);
  }

  Future<bool> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_timeFormatKey) ?? true; // mac dinh 24h
  }

  // ngon ngu (vi hoac en)
  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'vi'; // mac dinh tieng Viet
  }
}
