import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/convert_sensor_signal.dart';
import 'sensor_signal_event.dart';
import 'sensor_signal_state.dart';

class SensorSignalBloc extends Bloc<SensorSignalEvent, SensorSignalState> {
  final ConvertSensorSignal convertSensorSignal;

  SensorSignalBloc({required this.convertSensorSignal})
      : super(const SensorSignalInitial()) {
    on<ConvertSignalEvent>(_onConvertSignal);
  }

  Future<void> _onConvertSignal(
    ConvertSignalEvent event,
    Emitter<SensorSignalState> emit,
  ) async {
    final result = await convertSensorSignal(
      ConvertSensorSignalParams(
        signalType: event.signalType,
        minValue: event.minValue,
        maxValue: event.maxValue,
        valueUnit: event.valueUnit,
        searchValue: event.searchValue,
        direction: event.direction,
      ),
    );

    result.fold(
      (failure) => emit(SensorSignalError(message: _mapFailureToMessage(failure))),
      (conversionResult) => emit(SensorSignalLoaded(result: conversionResult)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    if (failure is ServerFailure) return failure.message;
    return 'Une erreur inattendue s\'est produite';
  }
}
