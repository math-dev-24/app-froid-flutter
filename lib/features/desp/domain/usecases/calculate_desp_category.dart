import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/desp_parameters.dart';
import '../entities/desp_result.dart';
import '../repositories/desp_repository.dart';

class CalculateDespCategory implements UseCase<DespResult, DespParameters> {
  final DespRepository repository;

  CalculateDespCategory(this.repository);

  @override
  Future<Either<Failure, DespResult>> call(DespParameters params) async {
    // Validation: le groupe de danger doit être 1 ou 2
    if (params.dangerGroup != 1 && params.dangerGroup != 2) {
      return Left(ValidationFailure('Le groupe de danger doit être 1 ou 2'));
    }

    // Validation: la pression doit être positive
    if (params.pressure < 0) {
      return Left(ValidationFailure('La pression doit être positive'));
    }

    return repository.calculate(params);
  }
}
