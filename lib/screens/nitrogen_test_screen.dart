import 'package:flutter/material.dart';

class NitrogenTestScreen extends StatefulWidget {
  const NitrogenTestScreen({super.key});

  @override
  State<NitrogenTestScreen> createState() => _NitrogenTestScreenState();
}

class _NitrogenTestScreenState extends State<NitrogenTestScreen> {
  double _pInit = 10;
  double _tInit = 25;
  double _tFinal = 20;

  final TextEditingController _pInitController = TextEditingController(text: '10');
  final TextEditingController _tInitController = TextEditingController(text: '25');
  final TextEditingController _tFinalController = TextEditingController(text: '20');

  @override
  void dispose() {
    _pInitController.dispose();
    _tInitController.dispose();
    _tFinalController.dispose();
    super.dispose();
  }

  // Calcul de la pression finale selon la loi des gaz parfaits (P1/T1 = P2/T2)
  double get _pFinal {
    final tInitKelvin = _tInit + 273.15;
    final tFinalKelvin = _tFinal + 273.15;

    if (tInitKelvin <= 0) return 0;

    return ((_pInit * tFinalKelvin / tInitKelvin) * 1000).round() / 1000;
  }

  // Différence de pression
  double get _pressureDifference {
    return ((_pFinal - _pInit) * 1000).round() / 1000;
  }

  // Pourcentage de variation
  double get _pressureVariationPercent {
    if (_pInit == 0) return 0;
    return ((_pressureDifference / _pInit) * 100 * 10).round() / 10;
  }

  // Déterminer si la variation est négligeable, modérée ou significative
  Map<String, dynamic> get _pressureSignificance {
    final absPercent = _pressureVariationPercent.abs();

    if (absPercent < 2) {
      return {
        'status': 'success',
        'message': 'Variation négligeable',
        'color': Colors.green,
      };
    } else if (absPercent < 5) {
      return {
        'status': 'warning',
        'message': 'Variation modérée',
        'color': Colors.amber,
      };
    } else {
      return {
        'status': 'error',
        'message': 'Variation significative',
        'color': Colors.red,
      };
    }
  }

  double get _tInitKelvin => _tInit + 273.15;
  double get _tFinalKelvin => _tFinal + 273.15;

  String get _temperatureChange {
    if (_tFinal > _tInit) {
      return 'Chauffage';
    } else if (_tFinal < _tInit) {
      return 'Refroidissement';
    } else {
      return 'Stable';
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
          'Test d\'Azote',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titre avec sous-titre
            Container(
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
            ),
            const SizedBox(height: 20),

            // Paramètres du test
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
                    onChanged: (value) {
                      setState(() {
                        _pInit = double.tryParse(value) ?? 0.0;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: 'Température initiale',
                    controller: _tInitController,
                    suffix: '°C',
                    onChanged: (value) {
                      setState(() {
                        _tInit = double.tryParse(value) ?? 0.0;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(
                    label: 'Température finale',
                    controller: _tFinalController,
                    suffix: '°C',
                    onChanged: (value) {
                      setState(() {
                        _tFinal = double.tryParse(value) ?? 0.0;
                      });
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),

                  // Explication
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
            ),
            const SizedBox(height: 20),

            // Visualisation
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
              child: Column(
                children: [
                  Row(
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
                                    '$_pInit bar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                  Text(
                                    '$_tInit°C',
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
                            _temperatureChange,
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
                              color: _pressureVariationPercent > 0
                                  ? Colors.red.withValues(alpha: 0.2)
                                  : colorScheme.primaryContainer.withValues(alpha: 0.3),
                              border: Border.all(
                                color: _pressureVariationPercent > 0
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
                                    '$_pFinal bar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '$_tFinal°C',
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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
              child: Column(
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
                          '$_pFinal bar',
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
                              _pressureSignificance['status'] == 'success'
                                  ? Icons.check_circle
                                  : _pressureSignificance['status'] == 'warning'
                                      ? Icons.warning_amber
                                      : Icons.error,
                              color: _pressureSignificance['color'],
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _pressureSignificance['message'],
                              style: TextStyle(
                                fontSize: 13,
                                color: _pressureSignificance['color'],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Détails de la variation
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
                          '${_pressureDifference > 0 ? '+' : ''}$_pressureDifference bar',
                          colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailCard(
                          'Variation relative',
                          '${_pressureVariationPercent > 0 ? '+' : ''}$_pressureVariationPercent%',
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
                          '${_tInitKelvin.toStringAsFixed(2)} K',
                          colorScheme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDetailCard(
                          'T finale (K)',
                          '${_tFinalKelvin.toStringAsFixed(2)} K',
                          colorScheme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Note informative
            Container(
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
            ),
          ],
        ),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          onChanged: onChanged,
        ),
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
