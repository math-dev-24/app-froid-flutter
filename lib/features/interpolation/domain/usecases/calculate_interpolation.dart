import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/interpolation_points.dart';
import '../entities/interpolation_result.dart';
import '../repositories/interpolation_repository.dart';

class CalculateInterpolation implements UseCase<InterpolationResult, InterpolationPoints> {
  final InterpolationRepository repository;

  CalculateInterpolation(this.repository);

  @override
  Future<Either<Failure, InterpolationResult>> call(InterpolationPoints params) async {
    // Validation: x2 ne doit pas être égal à x1
    if (params.x2 == params.x1) {
      return Left(ValidationFailure('X2 ne peut pas être égal à X1 (division par zéro)'));
    }

    return repository.calculate(params);
  }
}
