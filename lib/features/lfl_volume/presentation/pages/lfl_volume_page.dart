import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/core/di/injection_container.dart' as di;
import 'package:app_froid/features/lfl_volume/domain/entities/flammable_fluid.dart';
import 'package:app_froid/features/lfl_volume/domain/entities/lfl_parameters.dart';
import 'package:app_froid/features/lfl_volume/presentation/bloc/lfl_volume_bloc.dart';
import 'package:app_froid/features/lfl_volume/presentation/bloc/lfl_volume_event.dart';
import 'package:app_froid/features/lfl_volume/presentation/bloc/lfl_volume_state.dart';

class LflVolumePage extends StatelessWidget {
  const LflVolumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<LflVolumeBloc>()..add(LoadFluidsEvent()),
      child: const LflVolumeView(),
    );
  }
}

class LflVolumeView extends StatefulWidget {
  const LflVolumeView({super.key});

  @override
  State<LflVolumeView> createState() => _LflVolumeViewState();
}

class _LflVolumeViewState extends State<LflVolumeView> {
  FlammableFluid? _selectedFluid;
  double _fluidCharge = 20;
  double _ambientTemp = 20;
  double _safetyFactor = 0.7;
  double _roomVolume = 30;

  final TextEditingController _fluidChargeController =
      TextEditingController(text: '20');
  final TextEditingController _ambientTempController =
      TextEditingController(text: '20');

  @override
  void dispose() {
    _fluidChargeController.dispose();
    _ambientTempController.dispose();
    super.dispose();
  }

  double _getDensity(String refName) {
    switch (refName) {
      case 'PROPANE':
        return 1.83;
      case 'R32':
        return 2.15;
      case 'R1234YF':
        return 4.7;
      default:
        return 2.0;
    }
  }

  void _calculate() {
    if (_selectedFluid == null || _fluidCharge <= 0) return;

    final density = _getDensity(_selectedFluid!.refName);

    context.read<LflVolumeBloc>().add(
          CalculateLflVolumeEvent(
            parameters: LflParameters(
              fluidRefName: _selectedFluid!.refName,
              fluidCharge: _fluidCharge,
              ambientTemperature: _ambientTemp,
              density: density,
              lflLower: _selectedFluid!.lfl.lower,
            ),
            safetyFactor: _safetyFactor,
          ),
        );
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
      body: BlocConsumer<LflVolumeBloc, LflVolumeState>(
        listener: (context, state) {
          if (state is FluidsLoaded && _selectedFluid == null) {
            setState(() {
              _selectedFluid = state.fluids.first;
            });
            _calculate();
          }
        },
        builder: (context, state) {
          if (state is LflVolumeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LflVolumeError) {
            return Center(
              child: Text(
                'Erreur: ${state.message}',
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          final fluids = state is FluidsLoaded
              ? state.fluids
              : state is LflVolumeCalculated
                  ? state.fluids
                  : <FlammableFluid>[];

          if (fluids.isEmpty) {
            return const Center(child: Text('Aucun fluide disponible'));
          }

          _selectedFluid ??= fluids.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildConfigPanel(colorScheme, fluids),
                const SizedBox(height: 20),
                _buildResultsPanel(colorScheme, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfigPanel(ColorScheme colorScheme, List<FlammableFluid> fluids) {
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
              Expanded(
                child: Text(
                  'Paramètres de calcul',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildFluidSelector(colorScheme, fluids),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Charge de fluide frigorigène',
            controller: _fluidChargeController,
            suffix: 'kg',
            onChanged: (value) {
              setState(() => _fluidCharge = double.tryParse(value) ?? 0.0);
              _calculate();
            },
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: 'Température ambiante',
            controller: _ambientTempController,
            suffix: '°C',
            onChanged: (value) {
              setState(() => _ambientTemp = double.tryParse(value) ?? 0.0);
              _calculate();
            },
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 16),
          _buildSafetyFactorSlider(colorScheme),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: _calculate,
            icon: const Icon(Icons.calculate, size: 20),
            label: const Text('Calculer le volume minimum'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPanel(ColorScheme colorScheme, LflVolumeState state) {
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
              Icon(
                Icons.analytics,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Résultats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (state is LflVolumeCalculated) ...[
            _buildVolumeResult(colorScheme, state),
            const SizedBox(height: 20),
            _buildRoomVolumeComparison(colorScheme, state),
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
    );
  }

  Widget _buildVolumeResult(ColorScheme colorScheme, LflVolumeCalculated state) {
    final minVolumeLiters = (state.result.minimumVolumeM3 * 1000).round();
    final safetyVolumeLiters = (state.result.safetyVolumeM3 * 1000).round();

    return Container(
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
            '${state.result.minimumVolumeM3} m³ ($minVolumeLiters L)',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Avec marge: ${state.result.safetyVolumeM3} m³ ($safetyVolumeLiters L)',
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomVolumeComparison(
      ColorScheme colorScheme, LflVolumeCalculated state) {
    final maxAllowableCharge =
        ((_roomVolume * state.result.density * _selectedFluid!.lfl.lower) /
                    100 *
                    100)
                .round() /
            100;

    Color riskColor;
    String riskLevel;
    String riskMessage;
    IconData riskIcon;

    if (_fluidCharge > maxAllowableCharge) {
      riskColor = Colors.red;
      riskLevel = 'Élevé';
      riskMessage = 'Charge supérieure à la limite autorisée pour ce volume';
      riskIcon = Icons.error;
    } else if (_roomVolume < state.result.safetyVolumeM3) {
      riskColor = Colors.amber;
      riskLevel = 'Modéré';
      riskMessage =
          'Volume supérieur au minimum mais inférieur au volume de sécurité';
      riskIcon = Icons.warning_amber;
    } else {
      riskColor = Colors.green;
      riskLevel = 'Faible';
      riskMessage = 'Volume suffisant pour la charge spécifiée';
      riskIcon = Icons.check_circle;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          children: [
            Expanded(
              child: Slider(
                value: _roomVolume,
                min: 1,
                max: 100,
                divisions: 99,
                onChanged: (value) => setState(() => _roomVolume = value),
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: riskColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: riskColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(riskIcon, color: riskColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Risque $riskLevel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: riskColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                riskMessage,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
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
                'Pour un volume de $_roomVolume m³, la charge maximale de ${_selectedFluid!.refName} est de:',
                style: TextStyle(
                  fontSize: 11,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$maxAllowableCharge kg',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFluidSelector(ColorScheme colorScheme, List<FlammableFluid> fluids) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              items: fluids.map((fluid) {
                return DropdownMenuItem<FlammableFluid>(
                  value: fluid,
                  child: Text(fluid.name, style: const TextStyle(fontSize: 13)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedFluid = value);
                _calculate();
              },
            ),
          ),
        ),
        if (_selectedFluid != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _selectedFluid!.classification == 'A3'
                  ? Colors.red.withValues(alpha: 0.1)
                  : Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedFluid!.classification == 'A3'
                    ? Colors.red.withValues(alpha: 0.3)
                    : Colors.amber.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFluid!.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: _selectedFluid!.classification == 'A3'
                              ? Colors.red.shade700
                              : Colors.amber.shade700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _selectedFluid!.classification == 'A3'
                            ? Colors.red
                            : Colors.amber,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _selectedFluid!.classification,
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
                  _selectedFluid!.description,
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 4),
                Text(
                  'LFL: ${_selectedFluid!.lfl.lower}% - ${_selectedFluid!.lfl.upper}% (vol.)',
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ],
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
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSafetyFactorSlider(ColorScheme colorScheme) {
    return Column(
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
            setState(() => _safetyFactor = value);
            _calculate();
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
    );
  }
}
