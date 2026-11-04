import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'config/dependency_injector.dart';
import 'services/secure_storage_service.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

/// Entry point aplikasi[cite: 15].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Memuat file .env[cite: 15]
  await dotenv.load(fileName: ".env");

  if (!AppConfig.isConfigured()) {
    print('⚠️ Konfigurasi .env tidak lengkap. Periksa file .env Anda.');
  }

  final secureStorage = SecureStorageService();
  final token = await secureStorage.getToken();

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      child: MaterialApp(
        title: 'RPL & Keamanan Kode',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}