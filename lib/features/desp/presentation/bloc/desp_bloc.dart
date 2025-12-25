import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/desp_parameters.dart';
import '../../domain/usecases/calculate_desp_category.dart';
import 'desp_event.dart';
import 'desp_state.dart';

class DespBloc extends Bloc<DespEvent, DespState> {
  final CalculateDespCategory calculateDespCategory;

  DespBloc({required this.calculateDespCategory}) : super(const DespInitial()) {
    on<CalculateDespEvent>(_onCalculateDesp);
  }

  Future<void> _onCalculateDesp(
    CalculateDespEvent event,
    Emitter<DespState> emit,
  ) async {
    final parameters = DespParameters(
      equipmentType: event.equipmentType,
      fluidNature: event.fluidNature,
      dangerGroup: event.dangerGroup,
      pressure: event.pressure,
      volume: event.volume,
      nominalDiameter: event.nominalDiameter,
    );

    final result = await calculateDespCategory(parameters);

    result.fold(
      (failure) => emit(DespError(message: _mapFailureToMessage(failure))),
      (despResult) => emit(DespLoaded(
            result: despResult,
            equipmentType: event.equipmentType,
            fluidNature: event.fluidNature,
            dangerGroup: event.dangerGroup,
          )),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Une erreur inattendue s\'est produite';
  }
}
