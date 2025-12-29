import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/usecases/calculate_intermediate_pressure.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/bloc/intermediate_pressure_event.dart';
import 'package:app_froid/features/intermediate_pressure/presentation/bloc/intermediate_pressure_state.dart';

class IntermediatePressureBloc
    extends Bloc<IntermediatePressureEvent, IntermediatePressureState> {
  final CalculateIntermediatePressure calculateIntermediatePressure;

  IntermediatePressureBloc({
    required this.calculateIntermediatePressure,
  }) : super(IntermediatePressureInitial()) {
    on<CalculateIntermediatePressureEvent>(_onCalculateIntermediatePressure);
  }

  Future<void> _onCalculateIntermediatePressure(
    CalculateIntermediatePressureEvent event,
    Emitter<IntermediatePressureState> emit,
  ) async {
    emit(IntermediatePressureLoading());

    final parameters = PressureParameters(
      highPressure: event.highPressure,
      lowPressure: event.lowPressure,
    );

    final result = await calculateIntermediatePressure(parameters);

    result.fold(
      (failure) => emit(IntermediatePressureError(failure.message)),
      (pressureResult) => emit(IntermediatePressureLoaded(pressureResult)),
    );
  }
}
