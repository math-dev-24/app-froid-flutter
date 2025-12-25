import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import 'conversion_input_widget.dart';
import 'conversion_results_widget.dart';

/// Widget pour la conversion de pression
class PressureConverterWidget extends StatefulWidget {
  const PressureConverterWidget({super.key});

  @override
  State<PressureConverterWidget> createState() => _PressureConverterWidgetState();
}

class _PressureConverterWidgetState extends State<PressureConverterWidget> {
  final TextEditingController _controller = TextEditingController(text: '10');
  double _value = 10.0;
  String _unit = 'bar';
  final List<String> _units = ['bar', 'MPa', 'PSI', 'mce'];

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
          ConvertPressureEvent(
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
