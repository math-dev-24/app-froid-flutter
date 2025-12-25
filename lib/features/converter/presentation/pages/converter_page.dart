import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/conversion_type.dart';
import '../bloc/converter_bloc.dart';
import '../bloc/converter_event.dart';
import '../bloc/converter_state.dart';
import '../widgets/conversion_tab_widget.dart';
import '../widgets/pressure_converter_widget.dart';
import '../widgets/temperature_converter_widget.dart';

/// Page principale du convertisseur
class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ConverterBloc>(),
      child: const ConverterView(),
    );
  }
}

/// Vue de la page converter
class ConverterView extends StatelessWidget {
  const ConverterView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        title: const Text(
          'Convertisseur',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<ConverterBloc, ConverterState>(
        builder: (context, state) {
          return Column(
            children: [
              // Tabs Pression / Température
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ConversionTabWidget(
                        label: 'Pression',
                        icon: Icons.compress,
                        isActive: state.activeTab == ConversionType.pressure,
                        onTap: () => context.read<ConverterBloc>().add(
                              const ChangeTabEvent(ConversionType.pressure),
                            ),
                      ),
                    ),
                    Expanded(
                      child: ConversionTabWidget(
                        label: 'Température',
                        icon: Icons.thermostat,
                        isActive: state.activeTab == ConversionType.temperature,
                        onTap: () => context.read<ConverterBloc>().add(
                              const ChangeTabEvent(ConversionType.temperature),
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: state.activeTab == ConversionType.pressure
                      ? const PressureConverterWidget()
                      : const TemperatureConverterWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
