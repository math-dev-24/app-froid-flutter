import 'package:app_froid/data/list_fluids.dart';
import 'package:app_froid/data/list_ruler_mode.dart';
import 'package:app_froid/data/models/fluid.dart';
import 'package:app_froid/data/models/option_ruler.dart';
import 'package:flutter/material.dart';

class FormAdvancedRuler extends StatefulWidget {
  final void Function({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  })? onCalculate;

  const FormAdvancedRuler({
    super.key,
    this.onCalculate,
  });

  @override
  State<FormAdvancedRuler> createState() => _FormAdvancedRuler();
}

class _FormAdvancedRuler extends State<FormAdvancedRuler> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _val1Controller = TextEditingController();
  final TextEditingController _val2Controller = TextEditingController();

  Fluid _selectedFluid = ListFluids.fluids.first;
  OptionRuler _need = ListOptionsRuler.options.first;

  OptionRuler _car1 = ListOptionsRuler.options.first;
  double _val1 = 0.0;
  OptionRuler _car2 = ListOptionsRuler.options.first;
  double _val2 = 0.0;

  @override
  void dispose() {
    _val1Controller.dispose();
    _val2Controller.dispose();
    super.dispose();
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required String Function(T) getLabel,
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
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: colorScheme.primary),
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(getLabel(item)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
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
                          Icons.science_rounded,
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
                  _buildDropdown<Fluid>(
                    label: 'Fluide frigorigène',
                    value: _selectedFluid,
                    items: ListFluids.fluids,
                    getLabel: (fluid) => fluid.name,
                    onChanged: (Fluid? value) {
                      if (value != null && ListFluids.existFluid(value)) {
                        setState(() {
                          _selectedFluid = value;
                        });
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<OptionRuler>(
                    label: 'Paramètre recherché',
                    value: _need,
                    items: ListOptionsRuler.options.where((o) => o.canSearch).toList(),
                    getLabel: (option) => option.label,
                    onChanged: (OptionRuler? value) {
                      if (value != null && ListOptionsRuler.existOption(value)) {
                        setState(() {
                          _need = value;
                        });
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                          Icons.filter_1,
                          color: colorScheme.secondary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Filtre 1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<OptionRuler>(
                    label: 'Paramètre',
                    value: _car1,
                    items: ListOptionsRuler.options,
                    getLabel: (option) => option.label,
                    onChanged: (OptionRuler? value) {
                      if (value != null &&
                          ListOptionsRuler.existOption(value) &&
                          value != _need &&
                          value != _car2) {
                        setState(() {
                          _car1 = value;
                        });
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _val1Controller,
                    decoration: InputDecoration(
                      labelText: 'Valeur',
                      hintText: 'Entrez la valeur',
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
                      prefixIcon: Icon(Icons.edit, color: colorScheme.primary),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _val1 = double.tryParse(value) ?? 0.0;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une valeur';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                          color: colorScheme.tertiaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.filter_2,
                          color: colorScheme.tertiary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Filtre 2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown<OptionRuler>(
                    label: 'Paramètre',
                    value: _car2,
                    items: ListOptionsRuler.options,
                    getLabel: (option) => option.label,
                    onChanged: (OptionRuler? value) {
                      if (value != null &&
                          ListOptionsRuler.existOption(value) &&
                          value != _need &&
                          value != _car1) {
                        setState(() {
                          _car2 = value;
                        });
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _val2Controller,
                    decoration: InputDecoration(
                      labelText: 'Valeur',
                      hintText: 'Entrez la valeur',
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
                      prefixIcon: Icon(Icons.edit, color: colorScheme.primary),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      setState(() {
                        _val2 = double.tryParse(value) ?? 0.0;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une valeur';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Nombre invalide';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onCalculate?.call(
                      fluid: _selectedFluid,
                      car1: _car1.value,
                      val1: _val1,
                      car2: _car2.value,
                      val2: _val2,
                      carNeed: _need.value,
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.calculate_rounded),
                label: const Text(
                  'Calculer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
