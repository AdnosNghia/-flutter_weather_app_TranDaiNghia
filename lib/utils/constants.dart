import 'package:flutter/material.dart';

// cac hang so dung trong app
class AppConstants {
  // mau gradient cho tung dieu kien thoi tiet
  static const Map<String, List<Color>> weatherGradients = {
    'clear': [Color(0xFF4A90E2), Color(0xFF87CEEB)], // troi quang
    'clouds': [Color(0xFF8E9EAB), Color(0xFFEEF2F3)], // nhieu may
    'rain': [Color(0xFF4A5568), Color(0xFF718096)], // mua
    'drizzle': [Color(0xFF6B7B8D), Color(0xFF9CAAB8)], // mua phun
    'thunderstorm': [Color(0xFF232526), Color(0xFF414345)], // bao
    'snow': [Color(0xFFE6DADA), Color(0xFF274046)], // tuyet
    'mist': [Color(0xFFB6CEE8), Color(0xFFF5F7FA)], // suong mu
    'night': [Color(0xFF0F2027), Color(0xFF2C5364)], // ban dem
    'default': [Color(0xFF667EEA), Color(0xFF764BA2)], // mac dinh
  };

  // thoi gian cache (phut)
  static const int cacheDurationMinutes = 30;

  // so thanh pho yeu thich toi da
  static const int maxFavoriteCities = 5;

  // so lich su tim kiem toi da
  static const int maxSearchHistory = 10;
}
