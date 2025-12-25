import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../bloc/interpolation_bloc.dart';
import '../bloc/interpolation_event.dart';
import '../bloc/interpolation_state.dart';

class InterpolationPage extends StatelessWidget {
  const InterpolationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InterpolationBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Interpolation linéaire'),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InfoCard(),
              SizedBox(height: 16),
              _InterpolationForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Formule d\'interpolation linéaire',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Y = Y₁ + (X - X₁) × (Y₂ - Y₁) / (X₂ - X₁)',
              style: TextStyle(fontFamily: 'monospace', fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Entrez les coordonnées de deux points (X₁, Y₁) et (X₂, Y₂), '
              'puis la valeur X pour laquelle vous souhaitez interpoler Y.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InterpolationForm extends StatefulWidget {
  const _InterpolationForm();

  @override
  State<_InterpolationForm> createState() => _InterpolationFormState();
}

class _InterpolationFormState extends State<_InterpolationForm> {
  final _formKey = GlobalKey<FormState>();
  final _x1Controller = TextEditingController();
  final _y1Controller = TextEditingController();
  final _x2Controller = TextEditingController();
  final _y2Controller = TextEditingController();
  final _xController = TextEditingController();

  @override
  void dispose() {
    _x1Controller.dispose();
    _y1Controller.dispose();
    _x2Controller.dispose();
    _y2Controller.dispose();
    _xController.dispose();
    super.dispose();
  }

  void _calculate(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<InterpolationBloc>().add(
            CalculateInterpolationEvent(
              x1: double.parse(_x1Controller.text),
              y1: double.parse(_y1Controller.text),
              x2: double.parse(_x2Controller.text),
              y2: double.parse(_y2Controller.text),
              x: double.parse(_xController.text),
            ),
          );
    }
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer une valeur';
    }
    if (double.tryParse(value) == null) {
      return 'Valeur numérique invalide';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Point 1 (X₁, Y₁)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _x1Controller,
                          decoration: const InputDecoration(
                            labelText: 'X₁',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validateNumber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _y1Controller,
                          decoration: const InputDecoration(
                            labelText: 'Y₁',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validateNumber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Point 2 (X₂, Y₂)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _x2Controller,
                          decoration: const InputDecoration(
                            labelText: 'X₂',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validateNumber,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _y2Controller,
                          decoration: const InputDecoration(
                            labelText: 'Y₂',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validateNumber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Valeur à interpoler',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _xController,
                    decoration: const InputDecoration(
                      labelText: 'X',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: _validateNumber,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _calculate(context),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Calculer'),
          ),
          const SizedBox(height: 16),
          BlocBuilder<InterpolationBloc, InterpolationState>(
            builder: (context, state) {
              if (state is InterpolationLoaded) {
                return Card(
                  color: state.result.isOutOfRange
                      ? Colors.orange.shade50
                      : Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Résultat',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Y = ${state.result.y.toStringAsFixed(4)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state.result.warningMessage != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.warning_amber,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.result.warningMessage!,
                                  style: const TextStyle(color: Colors.orange),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              } else if (state is InterpolationError) {
                return Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
