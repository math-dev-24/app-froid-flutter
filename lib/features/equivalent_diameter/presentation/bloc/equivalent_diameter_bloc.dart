import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/duct_dimensions.dart';
import '../../domain/usecases/calculate_equivalent_diameter.dart';
import 'equivalent_diameter_event.dart';
import 'equivalent_diameter_state.dart';

class EquivalentDiameterBloc
    extends Bloc<EquivalentDiameterEvent, EquivalentDiameterState> {
  final CalculateEquivalentDiameter calculateEquivalentDiameter;

  EquivalentDiameterBloc({required this.calculateEquivalentDiameter})
      : super(const EquivalentDiameterInitial()) {
    on<CalculateDiameterEvent>(_onCalculateDiameter);
  }

  Future<void> _onCalculateDiameter(
    CalculateDiameterEvent event,
    Emitter<EquivalentDiameterState> emit,
  ) async {
    final dimensions = DuctDimensions(
      width: event.width,
      height: event.height,
    );

    final result = await calculateEquivalentDiameter(dimensions);

    result.fold(
      (failure) =>
          emit(EquivalentDiameterError(message: _mapFailureToMessage(failure))),
      (diameterResult) =>
          emit(EquivalentDiameterLoaded(result: diameterResult)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Une erreur inattendue s\'est produite';
  }
}
