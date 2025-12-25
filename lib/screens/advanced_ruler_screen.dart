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
  final RulerService _rulerService = getIt<RulerService>();

  double result = 0.0;
  bool isLoading = false;
  String resultUnit = '';

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
        resultUnit = _getUnitForParameter(carNeed);
      });
    } else {
      setState(() {
        result = 0.0;
        resultUnit = '';
      });
      NotificationService.showError(
        context,
        response.error ?? 'Erreur inconnue',
      );
    }
  }

  String _getUnitForParameter(String param) {
    switch (param) {
      case 'P':
        return 'bar';
      case 'T':
        return '°C';
      case 'H':
        return 'kJ/kg';
      case 'S':
        return 'kJ/kg.K';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: const Text(
          'Règlette avancée',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FormAdvancedRuler(
              onCalculate: _calculateRuler,
            ),
          ),
          if (result != 0.0 || isLoading)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorScheme.primaryContainer,
                    colorScheme.primaryContainer.withValues(alpha: 0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calculate_rounded,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Résultat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isLoading)
                    SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: colorScheme.primary,
                        ),
                      ),
                    )
                  else
                    Text(
                      '${result.toStringAsFixed(2)} $resultUnit',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
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
