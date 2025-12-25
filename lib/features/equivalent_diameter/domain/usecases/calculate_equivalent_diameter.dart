import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/diameter_result.dart';
import '../entities/duct_dimensions.dart';
import '../repositories/equivalent_diameter_repository.dart';

class CalculateEquivalentDiameter implements UseCase<DiameterResult, DuctDimensions> {
  final EquivalentDiameterRepository repository;

  CalculateEquivalentDiameter(this.repository);

  @override
  Future<Either<Failure, DiameterResult>> call(DuctDimensions params) async {
    // Validation: les dimensions doivent être positives
    if (params.width <= 0 || params.height <= 0) {
      return Left(ValidationFailure('Les dimensions doivent être positives'));
    }

    return repository.calculate(params);
  }
}
