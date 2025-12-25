import 'package:app_froid/data/models/fluid.dart';
import 'package:app_froid/services/notification_service.dart';
import 'package:app_froid/services/service_locator.dart';
import 'package:app_froid/services/rulers/ruler_service.dart';
import 'package:app_froid/widgets/ruler/form_ruler.dart';
import 'package:flutter/material.dart';

class RulerScreen extends StatefulWidget {
  const RulerScreen({super.key});

  @override
  State<RulerScreen> createState() => _RulerScreen();
}

class _RulerScreen extends State<RulerScreen> {
  // Injection du service via get_it
  final RulerService _rulerService = getIt<RulerService>();

  double result = 0.0;

  Future<void> _updateResult(Fluid fluid, double value) async {
    // Utilise le service pour calculer avec debouncing intégré
    final response = await _rulerService.calculateSimple(
      fluid: fluid,
      temperature: value,
    );

    if (!mounted) return;

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
    return "${result.toStringAsFixed(2)} bar";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Règlette'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            FormRuler(
              onSubmit: _updateResult,
            ),
            Text(_getResult()),
          ],
        ),
      ),
    );
  }
}
