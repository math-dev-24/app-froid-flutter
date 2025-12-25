import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/conversion_direction.dart';
import '../../domain/entities/sensor_conversion_result.dart';
import '../../domain/entities/signal_type.dart';
import '../../domain/repositories/sensor_signal_repository.dart';
import '../datasources/sensor_signal_local_datasource.dart';

/// Implémentation du repository de signal de capteur
class SensorSignalRepositoryImpl implements SensorSignalRepository {
  final SensorSignalLocalDataSource localDataSource;

  SensorSignalRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, SensorConversionResult> convert({
    required SignalType signalType,
    required double minValue,
    required double maxValue,
    required String valueUnit,
    required double searchValue,
    required ConversionDirection direction,
  }) {
    try {
      final result = localDataSource.convert(
        signalType: signalType,
        minValue: minValue,
        maxValue: maxValue,
        valueUnit: valueUnit,
        searchValue: searchValue,
        direction: direction,
      );
      return Right(result);
    } on ArgumentError catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur de conversion: ${e.toString()}'));
    }
  }

  @override
  List<SignalType> getAvailableSignalTypes() {
    return localDataSource.getAvailableSignalTypes();
  }

  @override
  List<String> getAvailableUnits() {
    return localDataSource.getAvailableUnits();
  }
}
