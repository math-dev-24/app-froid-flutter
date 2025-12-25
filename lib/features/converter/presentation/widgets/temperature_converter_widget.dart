import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import 'conversion_input_widget.dart';
import 'conversion_results_widget.dart';

/// Widget pour la conversion de température
class TemperatureConverterWidget extends StatefulWidget {
  const TemperatureConverterWidget({super.key});

  @override
  State<TemperatureConverterWidget> createState() => _TemperatureConverterWidgetState();
}

class _TemperatureConverterWidgetState extends State<TemperatureConverterWidget> {
  final TextEditingController _controller = TextEditingController(text: '55');
  double _value = 55.0;
  String _unit = '°C';
  final List<String> _units = ['K', '°C', '°F'];

  @override
  void initState() {
    super.initState();
    // Lancer la conversion initiale
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _convert();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _convert() {
    context.read<ConverterBloc>().add(
          ConvertTemperatureEvent(
            value: _value,
            fromUnit: _unit,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConversionInputWidget(
          controller: _controller,
          selectedUnit: _unit,
          units: _units,
          onValueChanged: (value) {
            setState(() {
              _value = value;
            });
            _convert();
          },
          onUnitChanged: (unit) {
            setState(() {
              _unit = unit;
            });
            _convert();
          },
        ),
        const SizedBox(height: 20),
        BlocBuilder<ConverterBloc, ConverterState>(
          builder: (context, state) {
            if (state is ConverterError) {
              return Center(
                child: Text(
                  state.message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              );
            } else if (state is ConverterLoaded) {
              return ConversionResultsWidget(conversions: state.conversions);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
