import 'package:app_froid/screens/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app_froid/screens/home_screen.dart';
import 'package:app_froid/services/service_locator.dart';

import 'package:app_froid/core/di/injection_container.dart';
import 'package:app_froid/features/ruler/presentation/pages/ruler_page.dart';
import 'package:app_froid/features/ruler/presentation/pages/advanced_ruler_page.dart';
import 'package:app_froid/features/converter/presentation/pages/converter_page.dart';
import 'package:app_froid/features/sensor_signal/presentation/pages/sensor_signal_page.dart';
import 'package:app_froid/features/interpolation/presentation/pages/interpolation_page.dart';
import 'package:app_froid/features/equivalent_diameter/presentation/pages/equivalent_diameter_page.dart';
import 'package:app_froid/features/nitrogen_test/presentation/pages/nitrogen_test_page.dart';
import 'package:app_froid/features/desp/presentation/pages/desp_page.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/pages/intermediate_pressure_page.dart';
import 'package:app_froid/features/refrigerant_charge/presentation/pages/refrigerant_charge_page.dart';
import 'package:app_froid/features/lfl_volume/presentation/pages/lfl_volume_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialiser l'ancienne architecture (pour les autres features)
  setupServiceLocator();

  // Initialiser la nouvelle architecture
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
        '/ruler-advanced': (context) => const AdvancedRulerPage(), // Nouvelle architecture
        '/sensor-convert': (context) => const SensorSignalPage(), // Nouvelle architecture
        '/converter': (context) => const ConverterPage(), // Nouvelle architecture
        '/interpolation': (context) => const InterpolationPage(), // Nouvelle architecture
        '/equivalent-diameter': (context) => const EquivalentDiameterPage(), // Nouvelle architecture
        '/nitrogen-test': (context) => const NitrogenTestPage(), // Nouvelle architecture
        '/desp': (context) => const DespPage(), // Nouvelle architecture
        '/intermediate-pressure': (context) => const IntermediatePressurePage(), // Nouvelle architecture
        '/refrigerant-charge': (context) => const RefrigerantChargePage(), // Nouvelle architecture
        '/lfl-volume': (context) => const LflVolumePage(), // Nouvelle architecture
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}