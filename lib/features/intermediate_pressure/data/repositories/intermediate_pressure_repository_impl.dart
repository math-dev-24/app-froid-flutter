import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/exceptions.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/intermediate_pressure/data/datasources/intermediate_pressure_local_datasource.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';
import 'package:app_froid/features/intermediate_pressure/domain/repositories/intermediate_pressure_repository.dart';

class IntermediatePressureRepositoryImpl
    implements IntermediatePressureRepository {
  final IntermediatePressureLocalDataSource localDataSource;

  IntermediatePressureRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PressureResult>> calculateIntermediatePressure(
    PressureParameters parameters,
  ) async {
    try {
      final result =
          await localDataSource.calculateIntermediatePressure(parameters);
      return Right(result);
    } on CalculationException catch (e) {
      return Left(CalculationFailure(e.message));
    } catch (e) {
      return Left(CalculationFailure(e.toString()));
    }
  }
}
