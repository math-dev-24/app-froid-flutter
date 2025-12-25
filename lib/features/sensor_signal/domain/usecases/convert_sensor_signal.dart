import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversion_direction.dart';
import '../entities/sensor_conversion_result.dart';
import '../entities/signal_type.dart';
import '../repositories/sensor_signal_repository.dart';

/// Use case pour convertir un signal de capteur
class ConvertSensorSignal
    implements UseCase<SensorConversionResult, ConvertSensorSignalParams> {
  final SensorSignalRepository repository;

  ConvertSensorSignal(this.repository);

  @override
  Future<Either<Failure, SensorConversionResult>> call(
      ConvertSensorSignalParams params) async {
    // Validation: minValue < maxValue
    if (params.minValue >= params.maxValue) {
      return const Left(
        ValidationFailure(
            'La valeur minimale doit être inférieure à la valeur maximale'),
      );
    }

    // Validation: searchValue dans les limites appropriées
    if (params.direction == ConversionDirection.signalToValue) {
      // Signal → Valeur
      if (params.searchValue < params.signalType.min ||
          params.searchValue > params.signalType.max) {
        return Left(
          ValidationFailure(
              'Le signal doit être entre ${params.signalType.min} et ${params.signalType.max} ${params.signalType.unit}'),
        );
      }
    } else {
      // Valeur → Signal
      if (params.searchValue < params.minValue ||
          params.searchValue > params.maxValue) {
        return Left(
          ValidationFailure(
              'La valeur doit être entre ${params.minValue} et ${params.maxValue} ${params.valueUnit}'),
        );
      }
    }

    // Validation des valeurs finies
    if (!params.minValue.isFinite ||
        !params.maxValue.isFinite ||
        !params.searchValue.isFinite) {
      return const Left(
        ValidationFailure('Toutes les valeurs doivent être des nombres valides'),
      );
    }

    // Délégation au repository
    return repository.convert(
      signalType: params.signalType,
      minValue: params.minValue,
      maxValue: params.maxValue,
      valueUnit: params.valueUnit,
      searchValue: params.searchValue,
      direction: params.direction,
    );
  }
}

/// Paramètres pour la conversion de signal
class ConvertSensorSignalParams extends Equatable {
  final SignalType signalType;
  final double minValue;
  final double maxValue;
  final String valueUnit;
  final double searchValue;
  final ConversionDirection direction;

  const ConvertSensorSignalParams({
    required this.signalType,
    required this.minValue,
    required this.maxValue,
    required this.valueUnit,
    required this.searchValue,
    required this.direction,
  });

  @override
  List<Object> get props =>
      [signalType, minValue, maxValue, valueUnit, searchValue, direction];
}
