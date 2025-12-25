import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/conversion_direction.dart';
import '../../domain/entities/signal_type.dart';
import '../../domain/repositories/sensor_signal_repository.dart';
import '../bloc/sensor_signal_bloc.dart';
import '../bloc/sensor_signal_event.dart';
import '../bloc/sensor_signal_state.dart';

/// Page pour la conversion de signaux de capteurs
class SensorSignalPage extends StatelessWidget {
  const SensorSignalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SensorSignalBloc>(),
      child: const SensorSignalView(),
    );
  }
}

class SensorSignalView extends StatefulWidget {
  const SensorSignalView({super.key});

  @override
  State<SensorSignalView> createState() => _SensorSignalViewState();
}

class _SensorSignalViewState extends State<SensorSignalView> {
  late List<SignalType> _signalTypes;
  late List<String> _units;

  SignalType? _selectedSignal;
  double _minValue = 0.0;
  double _maxValue = 10.0;
  String _valueUnit = '°C';
  ConversionDirection _direction = ConversionDirection.signalToValue;
  double _searchValue = 4.0;

  final _minController = TextEditingController(text: '0');
  final _maxController = TextEditingController(text: '10');
  final _searchController = TextEditingController(text: '4');

  @override
  void initState() {
    super.initState();
    final repo = getIt<SensorSignalRepository>();
    _signalTypes = repo.getAvailableSignalTypes();
    _units = repo.getAvailableUnits();
    _selectedSignal = _signalTypes.first;
    _convert();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _convert() {
    if (_selectedSignal == null) return;
    context.read<SensorSignalBloc>().add(
          ConvertSignalEvent(
            signalType: _selectedSignal!,
            minValue: _minValue,
            maxValue: _maxValue,
            valueUnit: _valueUnit,
            searchValue: _searchValue,
            direction: _direction,
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
        title: const Text('Signal Capteur', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    DropdownButton<SignalType>(
                      value: _selectedSignal,
                      isExpanded: true,
                      items: _signalTypes.map((s) => DropdownMenuItem(value: s, child: Text(s.label))).toList(),
                      onChanged: (v) { setState(() => _selectedSignal = v); _convert(); },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: TextField(controller: _minController, decoration: const InputDecoration(labelText: 'Min'), keyboardType: TextInputType.number, onChanged: (v) { _minValue = double.tryParse(v) ?? 0; _convert(); })),
                        const SizedBox(width: 12),
                        Expanded(child: TextField(controller: _maxController, decoration: const InputDecoration(labelText: 'Max'), keyboardType: TextInputType.number, onChanged: (v) { _maxValue = double.tryParse(v) ?? 0; _convert(); })),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DropdownButton<String>(
                      value: _valueUnit,
                      isExpanded: true,
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (v) { setState(() => _valueUnit = v ?? '°C'); _convert(); },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: RadioListTile<ConversionDirection>(title: const Text('Signal → Valeur'), value: ConversionDirection.signalToValue, groupValue: _direction, onChanged: (v) { setState(() => _direction = v!); _convert(); })),
                        Expanded(child: RadioListTile<ConversionDirection>(title: const Text('Valeur → Signal'), value: ConversionDirection.valueToSignal, groupValue: _direction, onChanged: (v) { setState(() => _direction = v!); _convert(); })),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: _searchController, decoration: const InputDecoration(labelText: 'Valeur à convertir'), keyboardType: TextInputType.number, onChanged: (v) { _searchValue = double.tryParse(v) ?? 0; _convert(); }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<SensorSignalBloc, SensorSignalState>(
              builder: (context, state) {
                if (state is SensorSignalError) {
                  return Card(color: colorScheme.errorContainer, child: Padding(padding: const EdgeInsets.all(20), child: Text(state.message, style: TextStyle(color: colorScheme.onErrorContainer))));
                } else if (state is SensorSignalLoaded) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(state.result.description, style: const TextStyle(fontSize: 14)),
                          const SizedBox(height: 12),
                          Text('${state.result.value.toStringAsFixed(2)} ${state.result.unit}', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: colorScheme.primary)),
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
      ),
    );
  }
}
