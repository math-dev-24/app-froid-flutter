import 'package:app_froid/screens/advanced_ruler_screen.dart';
import 'package:app_froid/screens/contact_screen.dart';
import 'package:app_froid/screens/intermediate_pressure_screen.dart';
import 'package:app_froid/screens/lfl_volume_screen.dart';
import 'package:app_froid/screens/refrigerant_charge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_froid/screens/home_screen.dart';
import 'package:app_froid/services/service_locator.dart';

import 'package:app_froid/core/di/injection_container.dart';
import 'package:app_froid/features/ruler/presentation/pages/ruler_page.dart';
import 'package:app_froid/features/converter/presentation/pages/converter_page.dart';
import 'package:app_froid/features/sensor_signal/presentation/pages/sensor_signal_page.dart';
import 'package:app_froid/features/interpolation/presentation/pages/interpolation_page.dart';
import 'package:app_froid/features/equivalent_diameter/presentation/pages/equivalent_diameter_page.dart';
import 'package:app_froid/features/nitrogen_test/presentation/pages/nitrogen_test_page.dart';
import 'package:app_froid/features/desp/presentation/pages/desp_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialiser l'ancienne architecture (pour les autres features)
  setupServiceLocator();

  // Initialiser la nouvelle architecture (pour Ruler, Converter, SensorSignal, Interpolation, EquivalentDiameter, NitrogenTest et DESP)
  await initializeDependencies();

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
        '/ruler': (context) => const RulerPage(), // Nouvelle architecture
        '/ruler-advanced': (context) => const AdvancedRulerScreen(),
        '/sensor-convert': (context) => const SensorSignalPage(), // Nouvelle architecture
        '/converter': (context) => const ConverterPage(), // Nouvelle architecture
        '/interpolation': (context) => const InterpolationPage(), // Nouvelle architecture
        '/equivalent-diameter': (context) => const EquivalentDiameterPage(), // Nouvelle architecture
        '/nitrogen-test': (context) => const NitrogenTestPage(), // Nouvelle architecture
        '/desp': (context) => const DespPage(), // Nouvelle architecture
        '/intermediate-pressure': (context) => const IntermediatePressureScreen(),
        '/refrigerant-charge': (context) => const RefrigerantChargeScreen(),
        '/lfl-volume': (context) => const LflVolumeScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}