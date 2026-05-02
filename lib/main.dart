import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/weather_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load file .env
  await dotenv.load(fileName: '.env');

  // khoi tao dinh dang ngay tieng Viet
  await initializeDateFormatting('vi', null);

  // thanh status bar trong suot
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(
          create: (_) {
            final provider = SettingsProvider();
            provider.loadSettings(); // load cai dat da luu
            return provider;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Weather App - Tran Dai Nghia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF667EEA),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF1A1A2E),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
