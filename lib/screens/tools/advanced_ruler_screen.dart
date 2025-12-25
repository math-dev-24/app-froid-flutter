import 'package:app_froid/data/models/fluid.dart';
import 'package:app_froid/services/notification_service.dart';
import 'package:app_froid/services/service_locator.dart';
import 'package:app_froid/services/rulers/ruler_service.dart';
import 'package:app_froid/widgets/ruler/form_advanced_ruler.dart';
import 'package:flutter/material.dart';

class AdvancedRulerScreen extends StatefulWidget {
  const AdvancedRulerScreen({super.key});

  @override
  State<AdvancedRulerScreen> createState() => _AdvancedRulerScreen();
}

class _AdvancedRulerScreen extends State<AdvancedRulerScreen> {
  // Injection du service via get_it
  final RulerService _rulerService = getIt<RulerService>();

  double result = 0.0;
  bool isLoading = false;

  void _calculateRuler({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    setState(() {
      isLoading = true;
    });

    // Utilise le service pour le calcul avancé
    final response = await _rulerService.calculateAdvanced(
      fluid: fluid,
      car1: car1,
      val1: val1,
      car2: car2,
      val2: val2,
      carNeed: carNeed,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (response.success) {
      setState(() {
        result = response.getValue('result') ?? 0.0;
      });
    } else {
      setState(() {
        result = 0.0;
      });
      NotificationService.showError(
        context,
        response.error ?? 'Erreur inconnue',
      );
    }
  }

  String _getResult() {
    return result.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Règlette avancé"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FormAdvancedRuler(
              onCalculate: _calculateRuler,
            ),
          ),
          if (result != 0.0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Résultat',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getResult(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
