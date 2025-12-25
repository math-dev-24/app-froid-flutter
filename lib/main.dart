import 'package:app_froid/screens/tools/advanced_ruler_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_froid/screens/home_screen.dart';
import 'package:app_froid/screens/tools/tool_screen.dart';
import 'package:app_froid/screens/tools/ruler_screen.dart';
import 'package:app_froid/services/service_locator.dart';
import 'package:app_froid/services/counter_service.dart';

void main() async {
  // Nécessaire pour initialiser les services avant runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Configure l'injection de dépendances
  setupServiceLocator();

  // Initialise le service du compteur
  await getIt.get<CounterService>().init();

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
        '/tools': (context) => const ToolScreen(),
        '/ruler': (context) => const RulerScreen(),
        '/ruler-advanced': (context) => const AdvancedRulerScreen()
      },
    );
  }
}