import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../providers/settings_provider.dart';
import '../models/weather_model.dart';
import '../utils/weather_utils.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/weather_error_widget.dart';
import 'search_screen.dart';
import 'forecast_screen.dart';
import 'settings_screen.dart';

// man hinh chinh hien thi thoi tiet
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // tai thoi tiet theo vi tri khi mo app
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Consumer<SettingsProvider>(
          builder: (context, settings, _) => Text(
            settings.isVietnamese ? 'Thời Tiết' : 'Weather',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        // nut tim kiem
        leading: IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
            if (result != null && result is String && mounted) {
              context.read<WeatherProvider>().fetchWeatherByCity(result);
            }
          },
        ),
        // nut cai dat
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: Consumer2<WeatherProvider, SettingsProvider>(
        builder: (context, weatherProvider, settings, child) {
          final isVi = settings.isVietnamese;
          // dong bo ngon ngu sang weather provider
          weatherProvider.setLanguage(settings.language);

          // dang tai
          if (weatherProvider.state == WeatherState.loading) {
            return const LoadingShimmer();
          }

          // loi va khong co cache
          if (weatherProvider.state == WeatherState.error &&
              weatherProvider.currentWeather == null) {
            return WeatherErrorWidget(
              message: weatherProvider.errorMessage,
              onRetry: () => weatherProvider.fetchWeatherByLocation(),
              retryText: isVi ? 'Thử lại' : 'Retry',
            );
          }

          // khong co du lieu
          if (weatherProvider.currentWeather == null) {
            return WeatherErrorWidget(
              message: isVi
                  ? 'Không có dữ liệu thời tiết.\nHãy tìm kiếm một thành phố.'
                  : 'No weather data.\nSearch for a city.',
              onRetry: () => weatherProvider.fetchWeatherByLocation(),
              retryText: isVi ? 'Thử lại' : 'Retry',
            );
          }

          final weather = weatherProvider.currentWeather!;

          return RefreshIndicator(
            onRefresh: () => weatherProvider.refreshWeather(),
            child: Container(
              decoration: BoxDecoration(
                gradient: WeatherUtils.getWeatherGradient(
                  weather.mainCondition,
                  dateTime: weather.dateTime,
                ),
              ),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // banner offline - hien thi khi khong co mang
                    if (weatherProvider.isOffline)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        color: weatherProvider.isDataOutdated
                            ? Colors.red.withAlpha(200)
                            : Colors.orange.withAlpha(200),
                        child: SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.wifi_off_rounded,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    weatherProvider.isDataOutdated
                                        ? (isVi
                                              ? 'Dữ liệu đệm đã lỗi thời'
                                              : 'Cached data is outdated')
                                        : (isVi
                                              ? 'Đang hiển thị dữ liệu đệm'
                                              : 'Showing cached data'),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (weatherProvider.lastUpdatedText.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    weatherProvider.lastUpdatedText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white.withAlpha(180),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                    // hien thi thoi gian cap nhat khi online
                    if (!weatherProvider.isOffline &&
                        weatherProvider.lastUpdatedText.isNotEmpty)
                      SafeArea(
                        bottom: false,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            weatherProvider.lastUpdatedText,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withAlpha(120),
                            ),
                          ),
                        ),
                      ),

                    // thoi tiet hien tai
                    CurrentWeatherCard(
                      weather: weather,
                      useFahrenheit: settings.useFahrenheit,
                      use24h: settings.use24h,
                      isVietnamese: isVi,
                    ),

                    // du bao theo gio
                    HourlyForecastList(
                      forecasts: weatherProvider.hourlyForecast,
                      useFahrenheit: settings.useFahrenheit,
                      use24h: settings.use24h,
                      isVietnamese: isVi,
                    ),

                    // du bao 5 ngay
                    DailyForecastCard(
                      forecasts: weatherProvider.dailyForecast,
                      useFahrenheit: settings.useFahrenheit,
                      isVietnamese: isVi,
                      onViewAll: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForecastScreen(
                            forecasts: weatherProvider.forecast,
                            cityName: weather.cityName,
                          ),
                        ),
                      ),
                    ),

                    // chi tiet thoi tiet
                    _buildDetailsSection(weather, settings),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // phan chi tiet thoi tiet
  Widget _buildDetailsSection(WeatherModel weather, SettingsProvider settings) {
    final isVi = settings.isVietnamese;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isVi ? 'Chi tiết' : 'Details',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6, // giam xuong de khong bi tran
            children: [
              WeatherDetailItem(
                icon: Icons.water_drop_rounded,
                label: isVi ? 'Độ ẩm' : 'Humidity',
                value: '${weather.humidity}%',
                iconColor: Colors.lightBlueAccent,
              ),
              WeatherDetailItem(
                icon: Icons.air_rounded,
                label: isVi ? 'Gió' : 'Wind',
                value: WeatherUtils.formatWindSpeed(
                  weather.windSpeed,
                  unit: settings.windUnit,
                ),
              ),
              WeatherDetailItem(
                icon: Icons.compress_rounded,
                label: isVi ? 'Áp suất' : 'Pressure',
                value: '${weather.pressure} hPa',
              ),
              WeatherDetailItem(
                icon: Icons.visibility_rounded,
                label: isVi ? 'Tầm nhìn' : 'Visibility',
                value: weather.visibility != null
                    ? '${(weather.visibility! / 1000).toStringAsFixed(1)} km'
                    : 'N/A',
              ),
              if (weather.sunrise != null)
                WeatherDetailItem(
                  icon: Icons.wb_sunny_outlined,
                  label: isVi ? 'Bình minh' : 'Sunrise',
                  value: WeatherUtils.formatTime(
                    weather.sunrise!,
                    use24h: settings.use24h,
                  ),
                  iconColor: Colors.orangeAccent,
                ),
              if (weather.sunset != null)
                WeatherDetailItem(
                  icon: Icons.nightlight_round,
                  label: isVi ? 'Hoàng hôn' : 'Sunset',
                  value: WeatherUtils.formatTime(
                    weather.sunset!,
                    use24h: settings.use24h,
                  ),
                  iconColor: Colors.deepOrangeAccent,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
