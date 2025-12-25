import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/calculate_advanced_ruler.dart';
import '../../domain/usecases/calculate_simple_ruler.dart';
import 'ruler_event.dart';
import 'ruler_state.dart';

/// Bloc pour gérer l'état de la fonctionnalité Ruler
///
/// Coordonne les événements UI avec les use cases métier
/// Transforme les Failures en messages d'erreur utilisateur
class RulerBloc extends Bloc<RulerEvent, RulerState> {
  final CalculateSimpleRuler calculateSimpleRuler;
  final CalculateAdvancedRuler calculateAdvancedRuler;

  RulerBloc({
    required this.calculateSimpleRuler,
    required this.calculateAdvancedRuler,
  }) : super(const RulerInitial()) {
    // Gestion de l'événement de calcul simple
    on<CalculateSimpleEvent>(_onCalculateSimple);

    // Gestion de l'événement de calcul avancé
    on<CalculateAdvancedEvent>(_onCalculateAdvanced);

    // Gestion de l'événement de réinitialisation
    on<ResetRulerEvent>(_onReset);
  }

  /// Handler pour le calcul simple
  Future<void> _onCalculateSimple(
    CalculateSimpleEvent event,
    Emitter<RulerState> emit,
  ) async {
    emit(const RulerLoading());

    final result = await calculateSimpleRuler(
      SimpleRulerParams(
        fluid: event.fluid,
        temperature: event.temperature,
      ),
    );

    result.fold(
      (failure) => emit(RulerError(message: _mapFailureToMessage(failure))),
      (calculationResult) => emit(RulerLoaded(result: calculationResult)),
    );
  }

  /// Handler pour le calcul avancé
  Future<void> _onCalculateAdvanced(
    CalculateAdvancedEvent event,
    Emitter<RulerState> emit,
  ) async {
    emit(const RulerLoading());

    final result = await calculateAdvancedRuler(
      AdvancedRulerParams(
        fluid: event.fluid,
        car1: event.car1,
        val1: event.val1,
        car2: event.car2,
        val2: event.val2,
        carNeed: event.carNeed,
      ),
    );

    result.fold(
      (failure) => emit(RulerError(message: _mapFailureToMessage(failure))),
      (calculationResult) => emit(RulerLoaded(result: calculationResult)),
    );
  }

  /// Handler pour la réinitialisation
  Future<void> _onReset(
    ResetRulerEvent event,
    Emitter<RulerState> emit,
  ) async {
    emit(const RulerInitial());
  }

  /// Convertit un Failure en message utilisateur
  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is ParsingFailure) {
      return failure.message;
    } else {
      return 'Une erreur inattendue s\'est produite';
    }
  }
}
