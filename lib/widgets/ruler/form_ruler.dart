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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                DropdownButton<Fluid>(
                  value: _selectedFluid,
                  icon: const Icon(Icons.arrow_downward),
                  items: ListFluids.fluids.map<DropdownMenuItem<Fluid>>((Fluid value) {
                    return DropdownMenuItem<Fluid>(value: value, child: Text(value.name));
                  }).toList(),
                  onChanged: (Fluid? value) {
                    if (value != null && ListFluids.existFluid(value)){
                      setState(() {
                        _selectedFluid = value;
                      });
                      if (widget.onSubmit != null) {
                        widget.onSubmit!(_selectedFluid, _value);
                      }
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Valeur: ${_value.toInt()}'),
            const SizedBox(height: 20),
            Slider(
              value: _value.clamp(_getMinValue(), _getMaxValue()),
              min: _getMinValue(),
              max: _getMaxValue(),
              divisions: (_getMaxValue() - _getMinValue()).toInt(),
              label: _value.toInt().toString(),
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
                if (widget.onSubmit != null) {
                  widget.onSubmit!(_selectedFluid, value);
                }
              },
            ),
          ],
        ),
      ));
  }
}