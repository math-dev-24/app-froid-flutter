import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/equipment_type.dart';
import '../../domain/entities/fluid_nature.dart';
import '../bloc/desp_bloc.dart';
import '../bloc/desp_event.dart';
import '../bloc/desp_state.dart';

class DespPage extends StatelessWidget {
  const DespPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DespBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catégorisation DESP'),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Description(),
              SizedBox(height: 20),
              _ConfigurationForm(),
              SizedBox(height: 20),
              _DespResults(),
              SizedBox(height: 20),
              _DisclaimerNote(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'Directive des Équipements Sous Pression (2014/68/UE)',
        style: TextStyle(
          fontSize: 13,
          color: colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ConfigurationForm extends StatefulWidget {
  const _ConfigurationForm();

  @override
  State<_ConfigurationForm> createState() => _ConfigurationFormState();
}

class _ConfigurationFormState extends State<_ConfigurationForm> {
  EquipmentType _equipmentType = EquipmentType.recipients;
  FluidNature _fluidNature = FluidNature.gaz;
  int _dangerGroup = 2;

  final _pressureController = TextEditingController(text: '40');
  final _volumeController = TextEditingController(text: '5');
  final _diameterController = TextEditingController(text: '20');

  @override
  void initState() {
    super.initState();
    _calculate();
  }

  @override
  void dispose() {
    _pressureController.dispose();
    _volumeController.dispose();
    _diameterController.dispose();
    super.dispose();
  }

  void _calculate() {
    final pressure = double.tryParse(_pressureController.text) ?? 0.0;
    final volume = double.tryParse(_volumeController.text) ?? 0.0;
    final diameter = double.tryParse(_diameterController.text) ?? 0.0;

    context.read<DespBloc>().add(
          CalculateDespEvent(
            equipmentType: _equipmentType,
            fluidNature: _fluidNature,
            dangerGroup: _dangerGroup,
            pressure: pressure,
            volume: volume,
            nominalDiameter: diameter,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Configuration
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
                    'Configuration',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDropdown<EquipmentType>(
                label: 'Type d\'équipement',
                value: _equipmentType,
                items: EquipmentType.values,
                itemLabel: (type) => type.label,
                onChanged: (value) {
                  setState(() {
                    _equipmentType = value!;
                    _calculate();
                  });
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
              _buildDropdown<FluidNature>(
                label: 'Nature du fluide',
                value: _fluidNature,
                items: FluidNature.values,
                itemLabel: (nature) => nature.label,
                onChanged: (value) {
                  setState(() {
                    _fluidNature = value!;
                    _calculate();
                  });
                },
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
              Text(
                'Groupe de danger',
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
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _dangerGroup = 1;
                          _calculate();
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _dangerGroup == 1
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        foregroundColor: _dangerGroup == 1
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                      child: const Text('Groupe 1'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _dangerGroup = 2;
                          _calculate();
                        });
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: _dangerGroup == 2
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        foregroundColor: _dangerGroup == 2
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                      child: const Text('Groupe 2'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Paramètres
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
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.tune,
                      color: colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Paramètres',
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
                label: 'Pression de service',
                controller: _pressureController,
                suffix: 'bar',
                help: 'PS: Pression maximale pour laquelle l\'équipement est conçu',
                onChanged: (_) => _calculate(),
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 16),
              if (_equipmentType == EquipmentType.recipients)
                _buildTextField(
                  label: 'Volume',
                  controller: _volumeController,
                  suffix: 'litres',
                  onChanged: (_) => _calculate(),
                  colorScheme: colorScheme,
                )
              else
                _buildTextField(
                  label: 'Diamètre nominal',
                  controller: _diameterController,
                  suffix: 'mm',
                  help: 'DN: Taille de la tuyauterie exprimée en mm',
                  onChanged: (_) => _calculate(),
                  colorScheme: colorScheme,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) itemLabel,
    required void Function(T?) onChanged,
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
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              borderRadius: BorderRadius.circular(12),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String suffix,
    String? help,
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
        if (help != null) ...[
          const SizedBox(height: 4),
          Text(
            help,
            style: TextStyle(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
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
}

class _DespResults extends StatelessWidget {
  const _DespResults();

  Color _getCategoryColor(String category, ColorScheme colorScheme) {
    switch (category) {
      case "Non soumis":
      case "Art 4§3":
        return colorScheme.outline;
      case "Cat I":
        return Colors.amber;
      case "Cat II":
        return Colors.orange;
      case "Cat III":
      case "Cat IV":
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<DespBloc, DespState>(
      builder: (context, state) {
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
                    Icons.calculate,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Détails du calcul',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (state is DespError)
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
              else if (state is DespLoaded) ...[
                _buildDetailRow(
                  'Groupe de danger',
                  state.dangerGroup == 1
                      ? 'Groupe 1 (dangereux)'
                      : 'Groupe 2 (Non dangereux)',
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Type',
                  state.equipmentType.label,
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  'Fluide',
                  state.fluidNature.label,
                  colorScheme,
                ),
                const SizedBox(height: 8),
                _buildDetailRow(
                  state.equipmentType == EquipmentType.tuyauterie
                      ? 'PS × DN'
                      : 'PS × V',
                  '${state.result.pvValue.toStringAsFixed(1)} ${state.result.pvUnit}',
                  colorScheme,
                ),
                const SizedBox(height: 20),
                // Catégorie DESP
                Container(
                  padding: const EdgeInsets.all(20),
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
                        'Catégorie DESP',
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.result.category,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: _getCategoryColor(
                              state.result.category, colorScheme),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.result.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerNote extends StatelessWidget {
  const _DisclaimerNote();

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Cet outil est fourni à titre indicatif. Pour toute application réglementaire officielle, veuillez vous référer au texte complet de la Directive des Équipements Sous Pression 2014/68/UE.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
