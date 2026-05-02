import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class WeatherUtils {
  // ngon ngu hien tai (duoc cap nhat tu settings)
  static String _locale = 'vi';

  // cap nhat ngon ngu
  static void setLocale(String lang) {
    _locale = lang;
  }

  // lay gradient dua tren dieu kien thoi tiet va thoi gian trong ngay
  static LinearGradient getWeatherGradient(
    String condition, {
    DateTime? dateTime,
  }) {
    final hour = dateTime?.hour ?? DateTime.now().hour;
    final isNight = hour < 6 || hour > 18;

    String key;
    if (isNight) {
      key = 'night';
    } else {
      key = condition.toLowerCase();
    }

    final colors =
        AppConstants.weatherGradients[key] ??
        AppConstants.weatherGradients['default']!;

    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  // lay icon cho tung loai thoi tiet
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'clouds':
        return Icons.cloud_rounded;
      case 'rain':
      case 'drizzle':
        return Icons.water_drop_rounded;
      case 'thunderstorm':
        return Icons.flash_on_rounded;
      case 'snow':
        return Icons.ac_unit_rounded;
      case 'mist':
      case 'haze':
      case 'fog':
        return Icons.blur_on_rounded;
      default:
        return Icons.cloud_rounded;
    }
  }

  // format nhiet do kem don vi
  static String formatTemp(double temp, {bool useFahrenheit = false}) {
    double value = useFahrenheit ? (temp * 9 / 5) + 32 : temp;
    return '${value.round()}°${useFahrenheit ? 'F' : 'C'}';
  }

  // format nhiet do ngan gon (chi co so va do)
  static String formatTempShort(double temp, {bool useFahrenheit = false}) {
    double value = useFahrenheit ? (temp * 9 / 5) + 32 : temp;
    return '${value.round()}°';
  }

  // format toc do gio
  static String formatWindSpeed(double speed, {String unit = 'm/s'}) {
    switch (unit) {
      case 'km/h':
        return '${(speed * 3.6).round()} km/h';
      case 'mph':
        return '${(speed * 2.237).round()} mph';
      default:
        return '${speed.round()} m/s';
    }
  }

  // format ngay thang (dung locale vi hoac en)
  static String formatDate(DateTime dt) {
    return DateFormat('EEEE, d MMMM', _locale).format(dt);
  }

  // format gio
  static String formatTime(DateTime dt, {bool use24h = true}) {
    if (use24h) {
      return DateFormat('HH:mm', _locale).format(dt);
    } else {
      return DateFormat('h:mm a', _locale).format(dt);
    }
  }

  // format gio ngan gon
  static String formatHour(DateTime dt, {bool use24h = true}) {
    if (use24h) {
      return DateFormat('HH:mm', _locale).format(dt);
    } else {
      return DateFormat('ha', _locale).format(dt);
    }
  }

  // format ten ngay (Thu 2, Thu 3,... hoac Mon, Tue,...)
  static String formatDayName(DateTime dt) {
    return DateFormat('EEE', _locale).format(dt);
  }

  // lay mau chu tuy theo nen sang hay toi
  static Color getTextColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clouds':
      case 'snow':
      case 'mist':
        return Colors.black87;
      default:
        return Colors.white;
    }
  }
}
