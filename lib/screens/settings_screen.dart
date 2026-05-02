import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';

// man hinh cai dat
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Consumer<SettingsProvider>(
          builder: (context, settings, _) => Text(
            settings.isVietnamese ? 'Cài đặt' : 'Settings',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          final isVi = settings.isVietnamese;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // don vi nhiet do
              _buildLabel(isVi ? 'Đơn vị nhiệt độ' : 'Temperature Unit'),
              _buildCard(
                icon: Icons.thermostat_rounded,
                title: isVi ? 'Đơn vị nhiệt độ' : 'Temperature Unit',
                subtitle: settings.useFahrenheit ? 'Fahrenheit (°F)' : 'Celsius (°C)',
                trailing: Switch(
                  value: settings.useFahrenheit,
                  onChanged: (_) => settings.toggleTempUnit(),
                  activeThumbColor: const Color(0xFF667EEA),
                ),
              ),

              const SizedBox(height: 16),

              // don vi gio
              _buildLabel(isVi ? 'Đơn vị tốc độ gió' : 'Wind Speed Unit'),
              _buildWindSelector(settings),

              const SizedBox(height: 16),

              // dinh dang gio
              _buildLabel(isVi ? 'Định dạng thời gian' : 'Time Format'),
              _buildCard(
                icon: Icons.access_time_rounded,
                title: isVi ? 'Định dạng 24 giờ' : '24-Hour Format',
                subtitle: settings.use24h ? '24h (14:00)' : '12h (2:00 PM)',
                trailing: Switch(
                  value: settings.use24h,
                  onChanged: (_) => settings.toggleTimeFormat(),
                  activeThumbColor: const Color(0xFF667EEA),
                ),
              ),

              const SizedBox(height: 16),

              // lua chon ngon ngu
              _buildLabel(isVi ? 'Ngôn ngữ' : 'Language'),
              _buildLanguageSelector(settings, context),

              const SizedBox(height: 24),

              // xoa cache
              _buildLabel(isVi ? 'Dữ liệu' : 'Data'),
              _buildCard(
                icon: Icons.delete_outline_rounded,
                title: isVi ? 'Xóa bộ nhớ đệm' : 'Clear Cache',
                subtitle: isVi
                    ? 'Xóa dữ liệu thời tiết và lịch sử tìm kiếm đã lưu'
                    : 'Delete saved weather data and search history',
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF2A2A4A),
                      title: Text(
                        isVi ? 'Xác nhận' : 'Confirm',
                        style: const TextStyle(color: Colors.white),
                      ),
                      content: Text(
                        isVi
                            ? 'Bạn có chắc muốn xóa tất cả dữ liệu đệm?'
                            : 'Are you sure you want to clear all cached data?',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(isVi ? 'Hủy' : 'Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(
                            isVi ? 'Xóa' : 'Delete',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await settings.clearCache();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isVi ? 'Đã xóa bộ nhớ đệm' : 'Cache cleared')),
                      );
                    }
                  }
                },
              ),

              const SizedBox(height: 32),

              // thong tin app
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.cloud_rounded, size: 40, color: Color(0xFF667EEA)),
                    const SizedBox(height: 8),
                    const Text(
                      'Weather App',
                      style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isVi ? 'Phiên bản 1.0.0' : 'Version 1.0.0',
                      style: TextStyle(color: Colors.white.withAlpha(80), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Lab 4 - Trần Đại Nghĩa',
                      style: TextStyle(color: Colors.white.withAlpha(80), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withAlpha(100),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: const Color(0xFF667EEA), size: 24),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 12),
        ),
        trailing: trailing,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildWindSelector(SettingsProvider settings) {
    final units = ['m/s', 'km/h', 'mph'];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.air_rounded, color: Color(0xFF667EEA), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: units.map((unit) {
                final selected = settings.windUnit == unit;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => settings.setWindUnit(unit),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF667EEA) : Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          unit,
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.white54,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(SettingsProvider settings, BuildContext context) {
    final languages = [
      {'code': 'vi', 'name': 'Tiếng Việt', 'flag': '🇻🇳'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.language_rounded, color: Color(0xFF667EEA), size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: languages.map((lang) {
                final selected = settings.language == lang['code'];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      settings.setLanguage(lang['code']!);
                      // tai lai du lieu thoi tiet theo ngon ngu moi
                      context.read<WeatherProvider>().refreshWeather();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF667EEA) : Colors.white.withAlpha(10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(lang['flag']!, style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              lang['name']!,
                              style: TextStyle(
                                color: selected ? Colors.white : Colors.white54,
                                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
