import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../utils/weather_utils.dart';

// card du bao 5 ngay
class DailyForecastCard extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final bool useFahrenheit;
  final bool isVietnamese;
  final VoidCallback? onViewAll;

  const DailyForecastCard({
    super.key,
    required this.forecasts,
    this.useFahrenheit = false,
    this.isVietnamese = true,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // tieu de
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isVietnamese ? 'Dự báo 5 ngày' : '5-Day Forecast',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    isVietnamese ? 'Xem thêm' : 'View all',
                    style: const TextStyle(fontSize: 14, color: Colors.white54),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // danh sach cac ngay
          ...forecasts.map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                // ten ngay
                SizedBox(
                  width: 50,
                  child: Text(
                    WeatherUtils.formatDayName(f.dateTime),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                // icon
                CachedNetworkImage(
                  imageUrl: ApiConfig.getIconUrl(f.icon),
                  height: 32,
                  width: 32,
                  errorWidget: (ctx, url, err) => Icon(
                    WeatherUtils.getWeatherIcon(f.mainCondition),
                    size: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 8),
                // xac suat mua
                if (f.pop != null && f.pop! > 0)
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${f.pop}%',
                      style: const TextStyle(fontSize: 12, color: Colors.lightBlueAccent),
                    ),
                  )
                else
                  const SizedBox(width: 40),
                const Spacer(),
                // nhiet do thap nhat
                Text(
                  WeatherUtils.formatTempShort(f.tempMin, useFahrenheit: useFahrenheit),
                  style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(150)),
                ),
                const SizedBox(width: 16),
                // nhiet do cao nhat
                Text(
                  WeatherUtils.formatTempShort(f.tempMax, useFahrenheit: useFahrenheit),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
