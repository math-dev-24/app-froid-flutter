import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/conversion_type.dart';
import '../../domain/usecases/convert_pressure.dart';
import '../../domain/usecases/convert_temperature.dart';
import 'converter_event.dart';
import 'converter_state.dart';

/// Bloc pour gérer l'état du convertisseur
class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  final ConvertPressure convertPressure;
  final ConvertTemperature convertTemperature;

  ConverterBloc({
    required this.convertPressure,
    required this.convertTemperature,
  }) : super(const ConverterInitial()) {
    on<ChangeTabEvent>(_onChangeTab);
    on<ConvertPressureEvent>(_onConvertPressure);
    on<ConvertTemperatureEvent>(_onConvertTemperature);
  }

  Future<void> _onChangeTab(
    ChangeTabEvent event,
    Emitter<ConverterState> emit,
  ) async {
    emit(ConverterInitial(activeTab: event.tab));
  }

  Future<void> _onConvertPressure(
    ConvertPressureEvent event,
    Emitter<ConverterState> emit,
  ) async {
    final result = await convertPressure(
      ConvertPressureParams(
        value: event.value,
        fromUnit: event.fromUnit,
      ),
    );

    result.fold(
      (failure) => emit(ConverterError(
        message: _mapFailureToMessage(failure),
        activeTab: ConversionType.pressure,
      )),
      (conversions) => emit(ConverterLoaded(
        conversions: conversions,
        activeTab: ConversionType.pressure,
      )),
    );
  }

  Future<void> _onConvertTemperature(
    ConvertTemperatureEvent event,
    Emitter<ConverterState> emit,
  ) async {
    final result = await convertTemperature(
      ConvertTemperatureParams(
        value: event.value,
        fromUnit: event.fromUnit,
      ),
    );

    result.fold(
      (failure) => emit(ConverterError(
        message: _mapFailureToMessage(failure),
        activeTab: ConversionType.temperature,
      )),
      (conversions) => emit(ConverterLoaded(
        conversions: conversions,
        activeTab: ConversionType.temperature,
      )),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'Une erreur inattendue s\'est produite';
    }
  }
}
