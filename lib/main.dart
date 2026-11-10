import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'config/dependency_injector.dart';
import 'screens/home_screen.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi dari file `.env` sebelum menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat file .env
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    Logger.error('File .env tidak dapat dimuat. Buat file .env di root proyek.');
  }

  // Periksa konfigurasi
  if (!AppConfig.isConfigured()) {
    Logger.warning('Konfigurasi .env tidak lengkap. Periksa file .env Anda.');
  }

  runApp(const MyApp());
}

/// Widget root aplikasi.
///
/// Menyediakan [DependencyInjector] ke seluruh widget tree.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DependencyProvider(
      injector: DependencyInjector.instance,
      child: MaterialApp(
        title: 'RPL & Keamanan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
