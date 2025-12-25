import 'package:equatable/equatable.dart';

import '../../domain/entities/fluid.dart';

/// Événements du Bloc Ruler
///
/// Représente toutes les actions que l'utilisateur peut effectuer
abstract class RulerEvent extends Equatable {
  const RulerEvent();

  @override
  List<Object> get props => [];
}

/// Événement pour effectuer un calcul simple (T -> P)
class CalculateSimpleEvent extends RulerEvent {
  final Fluid fluid;
  final double temperature;

  const CalculateSimpleEvent({
    required this.fluid,
    required this.temperature,
  });

  @override
  List<Object> get props => [fluid, temperature];
}

/// Événement pour effectuer un calcul avancé (paramètres personnalisés)
class CalculateAdvancedEvent extends RulerEvent {
  final Fluid fluid;
  final String car1;
  final double val1;
  final String car2;
  final double val2;
  final String carNeed;

  const CalculateAdvancedEvent({
    required this.fluid,
    required this.car1,
    required this.val1,
    required this.car2,
    required this.val2,
    required this.carNeed,
  });

  @override
  List<Object> get props => [fluid, car1, val1, car2, val2, carNeed];
}

/// Événement pour réinitialiser l'état du Bloc
class ResetRulerEvent extends RulerEvent {
  const ResetRulerEvent();
}
