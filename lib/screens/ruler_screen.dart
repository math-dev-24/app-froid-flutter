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
  final RulerService _rulerService = getIt<RulerService>();
  double result = 0.0;
  bool isLoading = false;

  Future<void> _updateResult(Fluid fluid, double value) async {
    setState(() {
      isLoading = true;
    });

    final response = await _rulerService.calculateSimple(
      fluid: fluid,
      temperature: value,
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
          'Règlette',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FormRuler(
                    onSubmit: _updateResult,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.speed,
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
                        height: 40,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: colorScheme.primary,
                          ),
                        ),
                      )
                    else
                      Text(
                        '${result.toStringAsFixed(2)} bar',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
