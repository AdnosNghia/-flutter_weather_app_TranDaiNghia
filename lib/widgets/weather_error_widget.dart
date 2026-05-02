import 'package:flutter/material.dart';

// widget hien thi loi kem nut thu lai
class WeatherErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String retryText;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.retryText = 'Thử lại',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 80,
                color: Colors.white.withAlpha(150),
              ),
              const SizedBox(height: 24),
              Text(
                'Đã xảy ra lỗi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withAlpha(220),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withAlpha(170),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(retryText),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF667EEA),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
