import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

// cac trang thai cua weather
enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();
  final ConnectivityService _connectivityService = ConnectivityService();

  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isOffline = false;
  DateTime? _lastUpdated; // thoi gian cap nhat cuoi
  String _language = 'vi'; // ngon ngu hien tai

  // getter
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdated => _lastUpdated;

  // dat ngon ngu (goi tu ben ngoai)
  void setLanguage(String lang) {
    _language = lang;
  }

  // lay du bao theo gio (8 muc = 24 gio, moi 3 gio 1 lan)
  List<ForecastModel> get hourlyForecast {
    if (_forecast.isEmpty) return [];
    return _forecast.take(8).toList();
  }

  // lay du bao theo ngay, nhom theo ngay roi lay 5 ngay
  List<ForecastModel> get dailyForecast {
    if (_forecast.isEmpty) return [];
    Map<String, ForecastModel> dailyMap = {};
    for (var item in _forecast) {
      String dayKey =
          '${item.dateTime.year}-${item.dateTime.month}-${item.dateTime.day}';
      if (!dailyMap.containsKey(dayKey)) {
        dailyMap[dayKey] = item;
      }
    }
    return dailyMap.values.take(5).toList();
  }

  // lay thoi tiet theo ten thanh pho
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      // kiem tra mang truoc
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        _isOffline = true;
        await _loadCachedWeather();
        if (_currentWeather == null) {
          _state = WeatherState.error;
          _errorMessage = 'Không có kết nối mạng và không có dữ liệu đệm.';
        }
        notifyListeners();
        return;
      }

      _isOffline = false;
      _currentWeather = await _weatherService.getCurrentWeatherByCity(
        cityName,
        lang: _language,
      );
      _forecast = await _weatherService.getForecast(cityName, lang: _language);
      _lastUpdated = DateTime.now();

      // luu cache thoi tiet va du bao
      await _storageService.saveWeatherData(_currentWeather!);
      await _storageService.saveForecastData(_forecast);
      await _storageService.addSearchHistory(cityName);

      _state = WeatherState.loaded;
      _errorMessage = '';
      print('Da tai thoi tiet thanh pho: $cityName'); // debug
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('Loi khi tai thoi tiet: $e'); // debug
      // thu tai du lieu cache
      await _loadCachedWeather();
    }

    notifyListeners();
  }

  // lay thoi tiet theo vi tri GPS hien tai
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final isConnected = await _connectivityService.isConnected();
      if (!isConnected) {
        _isOffline = true;
        await _loadCachedWeather();
        if (_currentWeather == null) {
          _state = WeatherState.error;
          _errorMessage = 'Không có kết nối mạng và không có dữ liệu đệm.';
        }
        notifyListeners();
        return;
      }

      _isOffline = false;
      final position = await _locationService.getCurrentLocation();
      print('Vi tri: ${position.latitude}, ${position.longitude}'); // debug

      _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
        position.latitude,
        position.longitude,
        lang: _language,
      );
      _forecast = await _weatherService.getForecastByCoordinates(
        position.latitude,
        position.longitude,
        lang: _language,
      );
      _lastUpdated = DateTime.now();

      // luu cache
      await _storageService.saveWeatherData(_currentWeather!);
      await _storageService.saveForecastData(_forecast);

      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      print('Loi location: $e'); // debug
      await _loadCachedWeather();
    }

    notifyListeners();
  }

  // tai du lieu da cache (ca thoi tiet va du bao)
  Future<void> _loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _forecast = await _storageService.getCachedForecast();
      _lastUpdated = await _storageService.getLastUpdateTime();
      _state = WeatherState.loaded;
      _isOffline = true;
      print('Da tai du lieu tu cache - $_lastUpdated'); // debug
    }
  }

  // lam moi du lieu thoi tiet
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }

  // kiem tra du lieu co loi thoi khong (qua 30 phut)
  bool get isDataOutdated {
    if (_lastUpdated == null) return true;
    return DateTime.now().difference(_lastUpdated!).inMinutes > 30;
  }

  // lay chuoi thoi gian cap nhat
  String get lastUpdatedText {
    if (_lastUpdated == null) return '';
    final diff = DateTime.now().difference(_lastUpdated!);
    if (diff.inMinutes < 1)
      return _language == 'vi' ? 'Vừa cập nhật' : 'Just updated';
    if (diff.inMinutes < 60) {
      return _language == 'vi'
          ? 'Cập nhật ${diff.inMinutes} phút trước'
          : 'Updated ${diff.inMinutes} min ago';
    }
    if (diff.inHours < 24) {
      return _language == 'vi'
          ? 'Cập nhật ${diff.inHours} giờ trước'
          : 'Updated ${diff.inHours}h ago';
    }
    return _language == 'vi'
        ? 'Cập nhật ${diff.inDays} ngày trước'
        : 'Updated ${diff.inDays} days ago';
  }

  // them thanh pho yeu thich (toi da 5)
  Future<bool> addFavoriteCity(String city) async {
    final favorites = await _storageService.getFavoriteCities();
    if (favorites.length >= 5) return false;
    if (favorites.contains(city)) return true;
    favorites.add(city);
    await _storageService.saveFavoriteCities(favorites);
    notifyListeners();
    return true;
  }

  // xoa thanh pho yeu thich
  Future<void> removeFavoriteCity(String city) async {
    final favorites = await _storageService.getFavoriteCities();
    favorites.remove(city);
    await _storageService.saveFavoriteCities(favorites);
    notifyListeners();
  }

  Future<List<String>> getFavoriteCities() async {
    return _storageService.getFavoriteCities();
  }

  Future<List<String>> getSearchHistory() async {
    return _storageService.getSearchHistory();
  }
}
