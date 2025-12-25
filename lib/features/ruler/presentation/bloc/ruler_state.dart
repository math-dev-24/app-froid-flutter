import 'package:equatable/equatable.dart';

import '../../domain/entities/calculation_result.dart';

/// États du Bloc Ruler
///
/// Représente tous les états possibles de l'interface utilisateur
abstract class RulerState extends Equatable {
  const RulerState();

  @override
  List<Object> get props => [];
}

/// État initial - aucun calcul effectué
class RulerInitial extends RulerState {
  const RulerInitial();
}

/// État de chargement - calcul en cours
class RulerLoading extends RulerState {
  const RulerLoading();
}

/// État de succès - résultat disponible
class RulerLoaded extends RulerState {
  final CalculationResult result;

  const RulerLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

/// État d'erreur - échec du calcul
class RulerError extends RulerState {
  final String message;

  const RulerError({required this.message});

  @override
  List<Object> get props => [message];
}
