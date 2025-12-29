import 'package:dartz/dartz.dart';
import 'package:app_froid/core/error/failures.dart';
import 'package:app_froid/core/usecases/usecase.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';
import 'package:app_froid/features/intermediate_pressure/domain/repositories/intermediate_pressure_repository.dart';

class CalculateIntermediatePressure
    implements UseCase<PressureResult, PressureParameters> {
  final IntermediatePressureRepository repository;

  CalculateIntermediatePressure(this.repository);

  @override
  Future<Either<Failure, PressureResult>> call(
    PressureParameters params,
  ) async {
    return await repository.calculateIntermediatePressure(params);
  }
}
