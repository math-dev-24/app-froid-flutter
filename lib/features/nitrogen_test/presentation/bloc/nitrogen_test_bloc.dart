import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/test_parameters.dart';
import '../../domain/usecases/calculate_nitrogen_test.dart';
import 'nitrogen_test_event.dart';
import 'nitrogen_test_state.dart';

class NitrogenTestBloc extends Bloc<NitrogenTestEvent, NitrogenTestState> {
  final CalculateNitrogenTest calculateNitrogenTest;

  NitrogenTestBloc({required this.calculateNitrogenTest})
      : super(const NitrogenTestInitial()) {
    on<CalculateTestEvent>(_onCalculateTest);
  }

  Future<void> _onCalculateTest(
    CalculateTestEvent event,
    Emitter<NitrogenTestState> emit,
  ) async {
    final parameters = TestParameters(
      initialPressure: event.initialPressure,
      initialTemperature: event.initialTemperature,
      finalTemperature: event.finalTemperature,
    );

    final result = await calculateNitrogenTest(parameters);

    result.fold(
      (failure) => emit(NitrogenTestError(message: _mapFailureToMessage(failure))),
      (testResult) => emit(NitrogenTestLoaded(result: testResult)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Une erreur inattendue s\'est produite';
  }
}
