import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';

abstract class IntermediatePressureRepository {
  Future<Either<Failure, PressureResult>> calculateIntermediatePressure(
    PressureParameters parameters,
  );
}
