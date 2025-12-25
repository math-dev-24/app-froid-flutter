import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/test_parameters.dart';
import '../entities/test_result.dart';
import '../repositories/nitrogen_test_repository.dart';

class CalculateNitrogenTest implements UseCase<TestResult, TestParameters> {
  final NitrogenTestRepository repository;

  CalculateNitrogenTest(this.repository);

  @override
  Future<Either<Failure, TestResult>> call(TestParameters params) async {
    // Validation: la température initiale en Kelvin doit être positive
    final tInitKelvin = params.initialTemperature + 273.15;
    if (tInitKelvin <= 0) {
      return Left(ValidationFailure('La température initiale doit être supérieure à -273.15°C'));
    }

    return repository.calculate(params);
  }
}
