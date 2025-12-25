import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/fluid.dart';
import '../bloc/ruler_bloc.dart';
import '../bloc/ruler_event.dart';
import '../bloc/ruler_state.dart';
import '../widgets/form_ruler_widget.dart';

/// Page principale pour la fonctionnalité Ruler
///
/// Utilise le BLoC pattern pour gérer l'état
class RulerPage extends StatelessWidget {
  const RulerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RulerBloc>(),
      child: const RulerView(),
    );
  }
}

/// Vue de la page Ruler
///
/// Séparée du BlocProvider pour faciliter les tests
class RulerView extends StatelessWidget {
  const RulerView({super.key});

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
          'Règlette',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FormRulerWidget(
                    onSubmit: (Fluid fluid, double temperature) {
                      // Déclencher l'événement de calcul
                      context.read<RulerBloc>().add(
                            CalculateSimpleEvent(
                              fluid: fluid,
                              temperature: temperature,
                            ),
                          );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildResultContainer(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultContainer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<RulerBloc, RulerState>(
      builder: (context, state) {
        return Container(
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
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.speed,
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
              _buildResultContent(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResultContent(BuildContext context, RulerState state) {
    final colorScheme = Theme.of(context).colorScheme;

    if (state is RulerLoading) {
      return SizedBox(
        height: 40,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: colorScheme.primary,
          ),
        ),
      );
    } else if (state is RulerError) {
      return Column(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            state.message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    } else if (state is RulerLoaded) {
      final pressure = state.result.getValue('result') ?? 0.0;
      return Text(
        '${pressure.toStringAsFixed(2)} bar',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      );
    } else {
      // État initial
      return Text(
        '0.00 bar',
        style: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary.withValues(alpha: 0.5),
        ),
      );
    }
  }
}
