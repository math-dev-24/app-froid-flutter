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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Section Fluide
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fluide',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Fluid>(
                          value: _selectedFluid,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
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
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Recherche
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recherché',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<OptionRuler>(
                          value: _need,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: ListOptionsRuler.options
                              .where((o) => o.canSearch)
                              .map((OptionRuler value) {
                            return DropdownMenuItem<OptionRuler>(
                              value: value,
                              child: Text(value.label),
                            );
                          }).toList(),
                          onChanged: (OptionRuler? value) {
                            if (value != null && ListOptionsRuler.existOption(value)) {
                              setState(() {
                                _need = value;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Filtre 1
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtre 1',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<OptionRuler>(
                          value: _car1,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: ListOptionsRuler.options.map((OptionRuler value) {
                            return DropdownMenuItem<OptionRuler>(
                              value: value,
                              child: Text(value.label),
                            );
                          }).toList(),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _val1Controller,
                      decoration: InputDecoration(
                        labelText: 'Valeur 1',
                        hintText: 'Entrez la valeur',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.edit),
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
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Section Filtre 2
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filtre 2',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<OptionRuler>(
                          value: _car2,
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                          items: ListOptionsRuler.options.map((OptionRuler value) {
                            return DropdownMenuItem<OptionRuler>(
                              value: value,
                              child: Text(value.label),
                            );
                          }).toList(),
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
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _val2Controller,
                      decoration: InputDecoration(
                        labelText: 'Valeur 2',
                        hintText: 'Entrez la valeur',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: const Icon(Icons.edit),
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
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bouton Calculer
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Calculer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}