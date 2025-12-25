import 'package:app_froid/data/list_fluids.dart';
import 'package:app_froid/data/models/fluid.dart';
import 'package:flutter/material.dart';

class FormRuler extends StatefulWidget {
  final void Function(Fluid fluid, double value)? onSubmit;

  const FormRuler({super.key, this.onSubmit});

  @override
  State<FormRuler> createState() => _FormRuler();
}

class _FormRuler extends State<FormRuler> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Fluid _selectedFluid = ListFluids.fluids.first;
  double _value = 10.0;

  double _getMinValue() {
    return _selectedFluid.tTriple ?? -50.0;
  }

  double _getMaxValue() {
    return _selectedFluid.tCrit ?? 150.0;
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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Fluid>(
                value: _selectedFluid,
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
                style: TextStyle(
                  fontSize: 16,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                items: ListFluids.fluids.map<DropdownMenuItem<Fluid>>((Fluid value) {
                  return DropdownMenuItem<Fluid>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (Fluid? value) {
                  if (value != null && ListFluids.existFluid(value)) {
                    setState(() {
                      _selectedFluid = value;
                    });
                    if (widget.onSubmit != null) {
                      widget.onSubmit!(_selectedFluid, _value);
                    }
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Température',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_value.toInt()}°C',
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
              divisions: (_getMaxValue() - _getMinValue()).toInt(),
              label: '${_value.toInt()}°C',
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
                if (widget.onSubmit != null) {
                  widget.onSubmit!(_selectedFluid, value);
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_getMinValue().toInt()}°C',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${_getMaxValue().toInt()}°C',
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
