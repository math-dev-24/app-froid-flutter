import 'package:flutter/material.dart';

class FlammableFluid {
  final String refName;
  final String name;
  final String classification;
  final String description;
  final LflRange lfl;

  const FlammableFluid({
    required this.refName,
    required this.name,
    required this.classification,
    required this.description,
    required this.lfl,
  });
}

class LflRange {
  final double lower;
  final double upper;

  const LflRange({required this.lower, required this.upper});
}

class LflVolumeScreen extends StatefulWidget {
  const LflVolumeScreen({super.key});

  @override
  State<LflVolumeScreen> createState() => _LflVolumeScreenState();
}

class _LflVolumeScreenState extends State<LflVolumeScreen> {
  static const List<FlammableFluid> flammableFluids = [
    FlammableFluid(
      refName: 'PROPANE',
      name: 'Propane (R290)',
      classification: 'A3',
      description: 'Fluide frigorigène naturel hautement inflammable',
      lfl: LflRange(lower: 2.1, upper: 9.5),
    ),
    FlammableFluid(
      refName: 'R32',
      name: 'R32',
      classification: 'A2L',
      description: 'Fluide HFC faiblement inflammable',
      lfl: LflRange(lower: 13.3, upper: 29.3),
    ),
    FlammableFluid(
      refName: 'R1234YF',
      name: 'R1234yf',
      classification: 'A2L',
      description: 'Fluide HFO faiblement inflammable, faible GWP',
      lfl: LflRange(lower: 6.2, upper: 12.3),
    ),
  ];

  FlammableFluid _selectedFluid = flammableFluids[0];
  double _fluidCharge = 20;
  double _ambiance = 20;
  double _safetyFactor = 0.7;
  double _roomVolume = 30;

  bool _isCalculated = false;
  bool _isLoading = false;
  double? _resultLowerM3;
  double? _density;

  final TextEditingController _fluidChargeController = TextEditingController(text: '20');
  final TextEditingController _ambianceController = TextEditingController(text: '20');

  @override
  void dispose() {
    _fluidChargeController.dispose();
    _ambianceController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (_fluidCharge <= 0) return;

    setState(() {
      _isLoading = true;
    });

    // Simulation de calcul de densité (normalement via API)
    // Pour simplifier, on utilise une densité approximative
    await Future.delayed(const Duration(milliseconds: 500));

    // Densité approximative du fluide (kg/m³) à température ambiante
    // En pratique, cela devrait venir d'une API ou d'un calcul thermodynamique
    double approximateDensity = 2.0; // Valeur par défaut

    if (_selectedFluid.refName == 'PROPANE') {
      approximateDensity = 1.83;
    } else if (_selectedFluid.refName == 'R32') {
      approximateDensity = 2.15;
    } else if (_selectedFluid.refName == 'R1234YF') {
      approximateDensity = 4.7;
    }

    setState(() {
      _density = approximateDensity;

      // LFL en kg/m³ = (LFL% × densité) / 100
      final lflLowerKgM3 = (_selectedFluid.lfl.lower * approximateDensity) / 100;

      // Volume minimum (m³) = Charge (kg) / LFL (kg/m³)
      _resultLowerM3 = ((_fluidCharge / lflLowerKgM3) * 1000).round() / 1000;

      _isCalculated = true;
      _isLoading = false;
    });
  }

  double get _safetyVolumeM3 {
    if (_resultLowerM3 == null) return 0;
    return ((_resultLowerM3! * (1 + _safetyFactor)) * 1000).round() / 1000;
  }

  int get _minVolumeLiters {
    if (_resultLowerM3 == null) return 0;
    return (_resultLowerM3! * 1000).round();
  }

  int get _safetyVolumeLiters {
    return (_safetyVolumeM3 * 1000).round();
  }

  double get _maxAllowableCharge {
    if (_density == null) return 0;
    return ((_roomVolume * _density! * _selectedFluid.lfl.lower) / 100 * 100).round() / 100;
  }

  Map<String, dynamic> get _riskLevel {
    if (_fluidCharge > _maxAllowableCharge) {
      return {
        'level': 'Élevé',
        'message': 'Charge supérieure à la limite autorisée pour ce volume',
        'color': Colors.red,
      };
    } else if (_roomVolume < _safetyVolumeM3) {
      return {
        'level': 'Modéré',
        'message': 'Volume supérieur au minimum mais inférieur au volume de sécurité',
        'color': Colors.amber,
      };
    } else {
      return {
        'level': 'Faible',
        'message': 'Volume suffisant pour la charge spécifiée',
        'color': Colors.green,
      };
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
          'Volume Mini LFL',
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
            Row(
              children: [
                // Panneau de configuration
                Expanded(
                  child: Container(
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
                              'Paramètres de calcul',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Fluide
                        Text(
                          'Fluide frigorigène',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.outline.withValues(alpha: 0.3),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<FlammableFluid>(
                              value: _selectedFluid,
                              isExpanded: true,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              borderRadius: BorderRadius.circular(12),
                              items: flammableFluids.map((fluid) {
                                return DropdownMenuItem<FlammableFluid>(
                                  value: fluid,
                                  child: Text(fluid.name, style: const TextStyle(fontSize: 13)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedFluid = value!;
                                  _isCalculated = false;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Info fluide
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _selectedFluid.classification == 'A3'
                                ? Colors.red.withValues(alpha: 0.1)
                                : Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _selectedFluid.classification == 'A3'
                                  ? Colors.red.withValues(alpha: 0.3)
                                  : Colors.amber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _selectedFluid.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedFluid.classification == 'A3'
                                          ? Colors.red.shade700
                                          : Colors.amber.shade700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: _selectedFluid.classification == 'A3'
                                          ? Colors.red
                                          : Colors.amber,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      _selectedFluid.classification,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedFluid.description,
                                style: const TextStyle(fontSize: 11),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'LFL: ${_selectedFluid.lfl.lower}% - ${_selectedFluid.lfl.upper}% (vol.)',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Charge
                        _buildTextField(
                          label: 'Charge de fluide frigorigène',
                          controller: _fluidChargeController,
                          suffix: 'kg',
                          onChanged: (value) {
                            setState(() {
                              _fluidCharge = double.tryParse(value) ?? 0.0;
                              _isCalculated = false;
                            });
                          },
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),

                        // Température
                        _buildTextField(
                          label: 'Température ambiante',
                          controller: _ambianceController,
                          suffix: '°C',
                          onChanged: (value) {
                            setState(() {
                              _ambiance = double.tryParse(value) ?? 0.0;
                              _isCalculated = false;
                            });
                          },
                          colorScheme: colorScheme,
                        ),
                        const SizedBox(height: 16),

                        // Facteur de sécurité
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Facteur de sécurité',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  '${(_safetyFactor * 100).round()}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Slider(
                              value: _safetyFactor,
                              min: 0.1,
                              max: 1.0,
                              divisions: 18,
                              onChanged: (value) {
                                setState(() {
                                  _safetyFactor = value;
                                });
                              },
                            ),
                            Text(
                              'Un facteur plus élevé signifie une plus grande marge de sécurité',
                              style: TextStyle(
                                fontSize: 11,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Bouton calcul
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _calculate,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.calculate, size: 20),
                          label: Text(_isLoading ? 'Calcul en cours...' : 'Calculer le volume minimum'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Panneau de résultats
                Expanded(
                  child: Container(
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
                              'Résultats',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if (_isLoading)
                          const Center(
                            child: Column(
                              children: [
                                SizedBox(height: 40),
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Calcul en cours...'),
                              ],
                            ),
                          )
                        else if (_isCalculated && _resultLowerM3 != null) ...[
                          // Volume minimum
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.green.withValues(alpha: 0.2),
                                  Colors.green.withValues(alpha: 0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Volume minimum requis',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_resultLowerM3 m³ ($_minVolumeLiters L)',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Avec marge: $_safetyVolumeM3 m³ ($_safetyVolumeLiters L)',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Comparaison
                          Text(
                            'Volume de pièce à comparer',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Slider(
                                  value: _roomVolume,
                                  min: 1,
                                  max: 100,
                                  divisions: 99,
                                  onChanged: (value) {
                                    setState(() {
                                      _roomVolume = value;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                '$_roomVolume m³',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Risque
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (_riskLevel['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: (_riskLevel['color'] as Color).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _riskLevel['level'] == 'Faible'
                                          ? Icons.check_circle
                                          : _riskLevel['level'] == 'Modéré'
                                              ? Icons.warning_amber
                                              : Icons.error,
                                      color: _riskLevel['color'],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Risque ${_riskLevel['level']}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _riskLevel['color'],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _riskLevel['message'],
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Charge maximale
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Charge maximale autorisée',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pour un volume de $_roomVolume m³, la charge maximale de ${_selectedFluid.refName} est de:',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$_maxAllowableCharge kg',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ] else
                          Center(
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                Icon(
                                  Icons.local_fire_department_outlined,
                                  size: 48,
                                  color: colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Remplissez les paramètres et cliquez sur "Calculer"',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Note
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
                    'À propos de la LFL (Limite Inférieure d\'Inflammabilité) :',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'La LFL représente la concentration minimale d\'un gaz ou d\'une vapeur nécessaire pour propager une flamme en présence d\'une source d\'inflammation. Pour les fluides frigorigènes inflammables, il est crucial que la concentration reste en dessous de cette limite en cas de fuite.',
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
