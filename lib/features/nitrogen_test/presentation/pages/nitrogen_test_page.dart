import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/variation_significance.dart';
import '../bloc/nitrogen_test_bloc.dart';
import '../bloc/nitrogen_test_event.dart';
import '../bloc/nitrogen_test_state.dart';

class NitrogenTestPage extends StatelessWidget {
  const NitrogenTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NitrogenTestBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test d\'Azote'),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoBanner(),
              SizedBox(height: 20),
              _TestParametersForm(),
              SizedBox(height: 20),
              _TestResults(),
              SizedBox(height: 20),
              _AboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.science,
            color: colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Influence de la Température',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TestParametersForm extends StatefulWidget {
  const _TestParametersForm();

  @override
  State<_TestParametersForm> createState() => _TestParametersFormState();
}

class _TestParametersFormState extends State<_TestParametersForm> {
  final _pInitController = TextEditingController(text: '10');
  final _tInitController = TextEditingController(text: '25');
  final _tFinalController = TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _pInitController.dispose();
    _tInitController.dispose();
    _tFinalController.dispose();
    super.dispose();
  }

  void _calculate() {
    final pInit = double.tryParse(_pInitController.text) ?? 0.0;
    final tInit = double.tryParse(_tInitController.text) ?? 0.0;
    final tFinal = double.tryParse(_tFinalController.text) ?? 0.0;

    context.read<NitrogenTestBloc>().add(
          CalculateTestEvent(
            initialPressure: pInit,
            initialTemperature: tInit,
            finalTemperature: tFinal,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.settings,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Paramètres du test',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Pression initiale',
            controller: _pInitController,
            suffix: 'bar',
            onChanged: (_) => _calculate(),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Température initiale',
            controller: _tInitController,
            suffix: '°C',
            onChanged: (_) => _calculate(),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Température finale',
            controller: _tFinalController,
            suffix: '°C',
            onChanged: (_) => _calculate(),
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: colorScheme.secondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Ce calculateur applique la loi des gaz parfaits pour déterminer l\'influence de la température sur la pression d\'azote. Utile pour évaluer si une variation de pression est due à une fuite ou simplement à un changement de température.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    required void Function(String) onChanged,
    required ColorScheme colorScheme,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            suffixText: suffix,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true, signed: true),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _TestResults extends StatelessWidget {
  const _TestResults();

  Color _getStatusColor(VariationStatus status) {
    switch (status) {
      case VariationStatus.success:
        return Colors.green;
      case VariationStatus.warning:
        return Colors.amber;
      case VariationStatus.error:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(VariationStatus status) {
    switch (status) {
      case VariationStatus.success:
        return Icons.check_circle;
      case VariationStatus.warning:
        return Icons.warning_amber;
      case VariationStatus.error:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<NitrogenTestBloc, NitrogenTestState>(
      builder: (context, state) {
        return Column(
          children: [
            // Visualisation
            if (state is NitrogenTestLoaded) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: _buildVisualization(context, state),
              ),
              const SizedBox(height: 20),
            ],
            // Résultats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
              child: _buildResults(context, state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVisualization(BuildContext context, NitrogenTestLoaded state) {
    final colorScheme = Theme.of(context).colorScheme;
    final pInit = double.tryParse(
            context.findAncestorStateOfType<_TestParametersFormState>()
                ?._pInitController.text ??
                '10') ??
        10;
    final tInit = double.tryParse(
            context.findAncestorStateOfType<_TestParametersFormState>()
                ?._tInitController.text ??
                '25') ??
        25;
    final tFinal = double.tryParse(
            context.findAncestorStateOfType<_TestParametersFormState>()
                ?._tFinalController.text ??
                '20') ??
        20;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Conteneur initial
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border.all(
                  color: colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Initial',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '$pInit bar',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '$tInit°C',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Flèche
        Column(
          children: [
            Icon(
              Icons.arrow_forward,
              color: colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              state.result.temperatureChange,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        // Conteneur final
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: state.result.pressureVariationPercent > 0
                    ? Colors.red.withValues(alpha: 0.2)
                    : colorScheme.primaryContainer.withValues(alpha: 0.3),
                border: Border.all(
                  color: state.result.pressureVariationPercent > 0
                      ? Colors.red
                      : colorScheme.primary,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Final',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${state.result.finalPressure} bar',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '$tFinal°C',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context, NitrogenTestState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.analytics,
              color: colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Résultats du test',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (state is NitrogenTestError)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline,
                  color: colorScheme.error,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.message,
                    style: TextStyle(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          )
        else if (state is NitrogenTestLoaded) ...[
          // Pression finale calculée
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Pression finale calculée',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.result.finalPressure} bar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatusIcon(state.result.significance.status),
                      color: _getStatusColor(state.result.significance.status),
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      state.result.significance.message,
                      style: TextStyle(
                        fontSize: 13,
                        color: _getStatusColor(state.result.significance.status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Détails de la variation',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  'Variation absolue',
                  '${state.result.pressureDifference > 0 ? '+' : ''}${state.result.pressureDifference} bar',
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  'Variation relative',
                  '${state.result.pressureVariationPercent > 0 ? '+' : ''}${state.result.pressureVariationPercent}%',
                  colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDetailCard(
                  'T initiale (K)',
                  '${state.result.initialTemperatureKelvin.toStringAsFixed(2)} K',
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailCard(
                  'T finale (K)',
                  '${state.result.finalTemperatureKelvin.toStringAsFixed(2)} K',
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDetailCard(String label, String value, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos du test d\'azote :',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Dans les systèmes frigorifiques, la pression d\'azote varie naturellement avec la température selon la loi de Charles-Gay-Lussac (P₁/T₁ = P₂/T₂). Lors d\'un test d\'étanchéité, il est important de déterminer si une baisse de pression est due à une fuite ou simplement à un changement de température.',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Formule utilisée : P₂ = P₁ × (T₂/T₁) où P est la pression en bar et T est la température en Kelvin.',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
