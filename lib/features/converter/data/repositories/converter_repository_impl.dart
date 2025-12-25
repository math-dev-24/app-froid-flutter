import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/conversion.dart';
import '../../domain/repositories/converter_repository.dart';
import '../datasources/converter_local_datasource.dart';

/// Implémentation du repository de conversion
///
/// Délègue les calculs à la datasource locale
class ConverterRepositoryImpl implements ConverterRepository {
  final ConverterLocalDataSource localDataSource;

  ConverterRepositoryImpl({required this.localDataSource});

  @override
  Either<Failure, List<Conversion>> convertPressure({
    required double value,
    required String fromUnit,
  }) {
    try {
      final result = localDataSource.convertPressure(
        value: value,
        fromUnit: fromUnit,
      );
      return Right(result);
    } on ArgumentError catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur de conversion: ${e.toString()}'));
    }
  }

  @override
  Either<Failure, List<Conversion>> convertTemperature({
    required double value,
    required String fromUnit,
  }) {
    try {
      final result = localDataSource.convertTemperature(
        value: value,
        fromUnit: fromUnit,
      );
      return Right(result);
    } on ArgumentError catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Erreur de conversion: ${e.toString()}'));
    }
  }
}
