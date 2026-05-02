import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/weather_utils.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  bool _useFahrenheit = false;
  String _windUnit = 'm/s';
  bool _use24h = true;
  String _language = 'vi'; // mac dinh tieng Viet

  // getter
  bool get useFahrenheit => _useFahrenheit;
  String get windUnit => _windUnit;
  bool get use24h => _use24h;
  String get language => _language;
  String get tempUnitLabel => _useFahrenheit ? '°F' : '°C';
  bool get isVietnamese => _language == 'vi';

  // load cai dat tu bo nho
  Future<void> loadSettings() async {
    _useFahrenheit = await _storageService.getTempUnit();
    _windUnit = await _storageService.getWindUnit();
    _use24h = await _storageService.getTimeFormat();
    _language = await _storageService.getLanguage();
    // cap nhat locale cho date format
    WeatherUtils.setLocale(_language);
    notifyListeners();
  }

  // chuyen doi don vi nhiet do
  Future<void> toggleTempUnit() async {
    _useFahrenheit = !_useFahrenheit;
    await _storageService.setTempUnit(_useFahrenheit);
    notifyListeners();
  }

  // dat don vi gio
  Future<void> setWindUnit(String unit) async {
    _windUnit = unit;
    await _storageService.setWindUnit(unit);
    notifyListeners();
  }

  // chuyen doi dinh dang gio
  Future<void> toggleTimeFormat() async {
    _use24h = !_use24h;
    await _storageService.setTimeFormat(_use24h);
    notifyListeners();
  }

  // doi ngon ngu
  Future<void> setLanguage(String lang) async {
    _language = lang;
    await _storageService.setLanguage(lang);
    // cap nhat locale cho date format luon
    WeatherUtils.setLocale(lang);
    notifyListeners();
  }

  // xoa tat ca du lieu cache
  Future<void> clearCache() async {
    await _storageService.clearCache();
    await _storageService.clearSearchHistory();
    notifyListeners();
  }
}
