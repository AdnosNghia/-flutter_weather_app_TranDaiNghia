import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/weather_model.dart';
import '../config/api_config.dart';
import '../utils/weather_utils.dart';

// card hien thi thoi tiet hien tai
class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  final bool useFahrenheit;
  final bool use24h;
  final bool isVietnamese;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
    this.useFahrenheit = false,
    this.use24h = true,
    this.isVietnamese = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = WeatherUtils.getTextColor(weather.mainCondition);
    final subColor = textColor.withAlpha(178);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        gradient: WeatherUtils.getWeatherGradient(
          weather.mainCondition,
          dateTime: weather.dateTime,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ten thanh pho
            Text(
              '${weather.cityName}, ${weather.country}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),

            // ngay thang
            Text(
              WeatherUtils.formatDate(weather.dateTime),
              style: TextStyle(fontSize: 14, color: subColor),
            ),
            const SizedBox(height: 20),

            // icon thoi tiet
            CachedNetworkImage(
              imageUrl: ApiConfig.getIconUrl(weather.icon, size: 4),
              height: 120,
              width: 120,
              placeholder: (context, url) => const SizedBox(
                height: 120,
                width: 120,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (context, url, error) => Icon(
                WeatherUtils.getWeatherIcon(weather.mainCondition),
                size: 80,
                color: textColor,
              ),
            ),

            // nhiet do
            Text(
              WeatherUtils.formatTempShort(weather.temperature, useFahrenheit: useFahrenheit),
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w200,
                color: textColor,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),

            // mo ta
            Text(
              weather.description[0].toUpperCase() + weather.description.substring(1),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),

            // cam giac nhu
            Text(
              isVietnamese
                  ? 'Cảm giác như ${WeatherUtils.formatTemp(weather.feelsLike, useFahrenheit: useFahrenheit)}'
                  : 'Feels like ${WeatherUtils.formatTemp(weather.feelsLike, useFahrenheit: useFahrenheit)}',
              style: TextStyle(fontSize: 14, color: subColor),
            ),
            const SizedBox(height: 8),

            // nhiet do thap nhat / cao nhat
            if (weather.tempMin != null && weather.tempMax != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_downward_rounded, size: 14, color: subColor),
                  Text(
                    WeatherUtils.formatTempShort(weather.tempMin!, useFahrenheit: useFahrenheit),
                    style: TextStyle(fontSize: 14, color: subColor),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.arrow_upward_rounded, size: 14, color: subColor),
                  Text(
                    WeatherUtils.formatTempShort(weather.tempMax!, useFahrenheit: useFahrenheit),
                    style: TextStyle(fontSize: 14, color: subColor),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
