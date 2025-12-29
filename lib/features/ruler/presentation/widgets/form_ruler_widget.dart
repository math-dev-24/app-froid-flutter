import 'package:flutter/material.dart';

import '../../../fluid_custom/presentation/widgets/fluid_dropdown_selector.dart';
import '../../data/datasources/fluids_local_data.dart';
import '../../domain/entities/fluid.dart';

export 'form_ruler_widget.dart' show RulerMode;

/// Mode de sélection : température ou pression
enum RulerMode { temperature, pressure }

/// Widget de formulaire pour la règlette simple
///
/// Permet de sélectionner un fluide et une température ou pression
class FormRulerWidget extends StatefulWidget {
  final void Function(Fluid fluid, double value, RulerMode mode)? onSubmit;

  const FormRulerWidget({super.key, this.onSubmit});

  @override
  State<FormRulerWidget> createState() => _FormRulerWidgetState();
}

class _FormRulerWidgetState extends State<FormRulerWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Fluid _selectedFluid = FluidsLocalData.fluids.first;
  double _value = 10.0;
  RulerMode _mode = RulerMode.pressure;

  double _getMinValue() {
    if (_mode == RulerMode.temperature) {
      return _selectedFluid.tTriple ?? -50.0;
    } else {
      return _selectedFluid.pTriple ?? 0.1;
    }
  }

  double _getMaxValue() {
    if (_mode == RulerMode.temperature) {
      return _selectedFluid.tCrit ?? 150.0;
    } else {
      return _selectedFluid.pCrit ?? 50.0;
    }
  }

  String _getUnit() {
    return _mode == RulerMode.temperature ? '°C' : 'bar';
  }

  String _getLabel() {
    return _mode == RulerMode.temperature ? 'Température' : 'Pression';
  }

  int _getDivisions() {
    final range = _getMaxValue() - _getMinValue();
    if (_mode == RulerMode.temperature) {
      return range.toInt();
    } else {
      // Pour la pression, on utilise des steps de 0.1 bar
      return (range * 10).toInt();
    }
  }

  String _formatValue(double value) {
    if (_mode == RulerMode.temperature) {
      return '${value.toInt()}${_getUnit()}';
    } else {
      return '${value.toStringAsFixed(1)}${_getUnit()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Fluide frigorigène',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          StyledFluidDropdownSelector(
            value: _selectedFluid,
            onChanged: (Fluid value) {
              setState(() {
                _selectedFluid = value;
                // Réinitialiser la valeur dans la plage du nouveau fluide
                final minVal = _getMinValue();
                final maxVal = _getMaxValue();
                _value = (_value.clamp(minVal, maxVal));
              });
              if (widget.onSubmit != null) {
                widget.onSubmit!(_selectedFluid, _value, _mode);
              }
            },
          ),
          const SizedBox(height: 24),
          // Toggle Temperature/Pressure
          Row(
            children: [
              Expanded(
                child: SegmentedButton<RulerMode>(
                  segments: const [
                    ButtonSegment<RulerMode>(
                      value: RulerMode.temperature,
                      label: Text('Température'),
                      icon: Icon(Icons.thermostat, size: 18),
                    ),
                    ButtonSegment<RulerMode>(
                      value: RulerMode.pressure,
                      label: Text('Pression'),
                      icon: Icon(Icons.speed, size: 18),
                    ),
                  ],
                  selected: {_mode},
                  onSelectionChanged: (Set<RulerMode> newSelection) {
                    setState(() {
                      _mode = newSelection.first;
                      // Réinitialiser la valeur pour le nouveau mode
                      final minVal = _getMinValue();
                      final maxVal = _getMaxValue();
                      _value = (minVal + maxVal) / 2;
                    });
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(_selectedFluid, _value, _mode);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getLabel(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _formatValue(_value),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary,
              inactiveTrackColor: colorScheme.surfaceContainerHighest,
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withValues(alpha: 0.2),
              valueIndicatorColor: colorScheme.primary,
              valueIndicatorTextStyle: TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
              trackHeight: 6,
            ),
            child: Slider(
              value: _value.clamp(_getMinValue(), _getMaxValue()),
              min: _getMinValue(),
              max: _getMaxValue(),
              divisions: _getDivisions(),
              label: _formatValue(_value),
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
                if (widget.onSubmit != null) {
                  widget.onSubmit!(_selectedFluid, value, _mode);
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatValue(_getMinValue()),
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                _formatValue(_getMaxValue()),
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
