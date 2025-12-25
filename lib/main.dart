import 'package:app_froid/screens/advanced_ruler_screen.dart';
import 'package:app_froid/screens/converter_screen.dart';
import 'package:app_froid/screens/equivalent_diameter_screen.dart';
import 'package:app_froid/screens/interpolation_screen.dart';
import 'package:app_froid/screens/sensor_convert_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_froid/screens/home_screen.dart';
import 'package:app_froid/screens/ruler_screen.dart';
import 'package:app_froid/services/service_locator.dart';

void main() async {
  // Nécessaire pour initialiser les services avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Configure l'injection de dépendances
  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Froid',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const HomeScreen(title: 'App Froid'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/ruler': (context) => const RulerScreen(),
        '/ruler-advanced': (context) => const AdvancedRulerScreen(),
        '/sensor-convert': (context) => const SensorConvertScreen(),
        '/converter': (context) => const ConverterScreen(),
        '/equivalent-diameter': (context) => const EquivalentDiameterScreen(),
        '/interpolation': (context) => const InterpolationScreen(),
      },
    );
  }
}