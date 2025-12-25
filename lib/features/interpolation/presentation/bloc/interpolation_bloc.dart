import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/interpolation_points.dart';
import '../../domain/usecases/calculate_interpolation.dart';
import 'interpolation_event.dart';
import 'interpolation_state.dart';

class InterpolationBloc extends Bloc<InterpolationEvent, InterpolationState> {
  final CalculateInterpolation calculateInterpolation;

  InterpolationBloc({required this.calculateInterpolation})
      : super(const InterpolationInitial()) {
    on<CalculateInterpolationEvent>(_onCalculateInterpolation);
  }

  Future<void> _onCalculateInterpolation(
    CalculateInterpolationEvent event,
    Emitter<InterpolationState> emit,
  ) async {
    final points = InterpolationPoints(
      x1: event.x1,
      y1: event.y1,
      x2: event.x2,
      y2: event.y2,
      x: event.x,
    );

    final result = await calculateInterpolation(points);

    result.fold(
      (failure) => emit(InterpolationError(message: _mapFailureToMessage(failure))),
      (interpolationResult) => emit(InterpolationLoaded(result: interpolationResult)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Une erreur inattendue s\'est produite';
  }
}
