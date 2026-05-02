import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';
import '../providers/settings_provider.dart';
import '../config/api_config.dart';
import '../utils/weather_utils.dart';

// man hinh du bao chi tiet 5 ngay
class ForecastScreen extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final String cityName;

  const ForecastScreen({
    super.key,
    required this.forecasts,
    required this.cityName,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isVi = settings.isVietnamese;

    // nhom du bao theo ngay
    final Map<String, List<ForecastModel>> grouped = {};
    for (var f in forecasts) {
      final key = '${f.dateTime.year}-${f.dateTime.month}-${f.dateTime.day}';
      grouped.putIfAbsent(key, () => []).add(f);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isVi ? 'Dự báo - $cityName' : 'Forecast - $cityName',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final dayKey = grouped.keys.elementAt(index);
          final dayForecasts = grouped[dayKey]!;
          final first = dayForecasts.first;

          // tinh nhiet do min/max cua ngay
          double minTemp = dayForecasts.map((f) => f.tempMin).reduce((a, b) => a < b ? a : b);
          double maxTemp = dayForecasts.map((f) => f.tempMax).reduce((a, b) => a > b ? a : b);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              iconColor: Colors.white54,
              collapsedIconColor: Colors.white38,
              title: Text(
                WeatherUtils.formatDate(first.dateTime),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: ApiConfig.getIconUrl(first.icon),
                    height: 28,
                    width: 28,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${WeatherUtils.formatTempShort(minTemp, useFahrenheit: settings.useFahrenheit)} / ${WeatherUtils.formatTempShort(maxTemp, useFahrenheit: settings.useFahrenheit)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              // chi tiet tung gio trong ngay
              children: dayForecasts.map((f) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        WeatherUtils.formatHour(f.dateTime, use24h: settings.use24h),
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                    CachedNetworkImage(
                      imageUrl: ApiConfig.getIconUrl(f.icon),
                      height: 28,
                      width: 28,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        f.description[0].toUpperCase() + f.description.substring(1),
                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    ),
                    Text(
                      WeatherUtils.formatTempShort(f.temperature, useFahrenheit: settings.useFahrenheit),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          );
        },
      ),
    );
  }
}
