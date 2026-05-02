import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';
import '../config/api_config.dart';
import '../utils/weather_utils.dart';

// danh sach du bao theo gio (cuon ngang)
class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  final bool useFahrenheit;
  final bool use24h;
  final bool isVietnamese;

  const HourlyForecastList({
    super.key,
    required this.forecasts,
    this.useFahrenheit = false,
    this.use24h = true,
    this.isVietnamese = true,
  });

  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              isVietnamese ? 'Dự báo theo giờ' : 'Hourly Forecast',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: forecasts.length,
              itemBuilder: (context, index) {
                final forecast = forecasts[index];
                return Container(
                  width: 70,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(index == 0 ? 40 : 20),
                    borderRadius: BorderRadius.circular(20),
                    border: index == 0
                        ? Border.all(color: Colors.white.withAlpha(60))
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // gio
                      Text(
                        index == 0
                            ? (isVietnamese ? 'Bây giờ' : 'Now')
                            : WeatherUtils.formatHour(forecast.dateTime, use24h: use24h),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withAlpha(200),
                          fontWeight: index == 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      // icon
                      CachedNetworkImage(
                        imageUrl: ApiConfig.getIconUrl(forecast.icon),
                        height: 36,
                        width: 36,
                        errorWidget: (ctx, url, err) => Icon(
                          WeatherUtils.getWeatherIcon(forecast.mainCondition),
                          size: 24,
                          color: Colors.white70,
                        ),
                      ),
                      // nhiet do
                      Text(
                        WeatherUtils.formatTempShort(forecast.temperature, useFahrenheit: useFahrenheit),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
