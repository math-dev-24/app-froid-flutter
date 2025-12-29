import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/core/di/injection_container.dart' as di;
import 'package:app_froid/data/models/fluid.dart' as old_fluid;
import 'package:app_froid/features/ruler/domain/entities/fluid.dart' as new_fluid;
import 'package:app_froid/features/ruler/presentation/bloc/ruler_bloc.dart';
import 'package:app_froid/features/ruler/presentation/bloc/ruler_event.dart';
import 'package:app_froid/features/ruler/presentation/bloc/ruler_state.dart';
import 'package:app_froid/widgets/ruler/form_advanced_ruler.dart';

class AdvancedRulerPage extends StatelessWidget {
  const AdvancedRulerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.getIt<RulerBloc>(),
      child: const AdvancedRulerView(),
    );
  }
}

class AdvancedRulerView extends StatefulWidget {
  const AdvancedRulerView({super.key});

  @override
  State<AdvancedRulerView> createState() => _AdvancedRulerViewState();
}

class _AdvancedRulerViewState extends State<AdvancedRulerView> {
  String _currentCarNeed = '';

  String _getUnitForParameter(String param) {
    switch (param) {
      case 'P':
        return 'bar';
      case 'T':
        return '°C';
      case 'H':
        return 'kJ/kg';
      case 'S':
        return 'kJ/kg.K';
      default:
        return '';
    }
  }

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
          'Règlette avancée',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<RulerBloc, RulerState>(
        builder: (context, state) {
          final isLoading = state is RulerLoading;
          final resultValue = state is RulerLoaded
              ? state.result.getValue('result') ?? 0.0
              : 0.0;
          final resultUnit = _getUnitForParameter(_currentCarNeed);
          final hasResult = resultValue != 0.0 || isLoading;

          return Column(
            children: [
              Expanded(
                child: FormAdvancedRuler(
                  onCalculate: ({
                    required old_fluid.Fluid fluid,
                    required String car1,
                    required double val1,
                    required String car2,
                    required double val2,
                    required String carNeed,
                  }) {
                    setState(() {
                      _currentCarNeed = carNeed;
                    });

                    // Convertir l'ancien Fluid vers le nouveau Fluid
                    final newFluid = new_fluid.Fluid(
                      name: fluid.name,
                      refName: fluid.refName,
                    );

                    context.read<RulerBloc>().add(
                          CalculateAdvancedEvent(
                            fluid: newFluid,
                            car1: car1,
                            val1: val1,
                            car2: car2,
                            val2: val2,
                            carNeed: carNeed,
                          ),
                        );
                  },
                ),
              ),
              if (hasResult)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.primaryContainer.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withValues(alpha: 0.15),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calculate_rounded,
                            color: colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Résultat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (isLoading)
                        SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: colorScheme.primary,
                            ),
                          ),
                        )
                      else if (state is RulerError)
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 16,
                            color: colorScheme.error,
                          ),
                        )
                      else
                        Text(
                          '${resultValue.toStringAsFixed(2)} $resultUnit',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
