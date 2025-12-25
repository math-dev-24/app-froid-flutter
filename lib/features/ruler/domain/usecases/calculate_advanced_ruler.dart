import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculation_result.dart';
import '../entities/fluid.dart';
import '../repositories/ruler_repository.dart';

/// Use case pour effectuer un calcul avancé de règlette
///
/// Permet de calculer n'importe quelle propriété thermodynamique
/// à partir de deux propriétés connues
class CalculateAdvancedRuler
    implements UseCase<CalculationResult, AdvancedRulerParams> {
  final RulerRepository repository;

  CalculateAdvancedRuler(this.repository);

  @override
  Future<Either<Failure, CalculationResult>> call(
      AdvancedRulerParams params) async {
    // Validation des caractères
    final validChars = ['P', 'T', 'H', 'Q'];
    if (!validChars.contains(params.car1)) {
      return Left(
        ValidationFailure(
            'Le premier caractère doit être P, T, H ou Q (reçu: ${params.car1})'),
      );
    }
    if (!validChars.contains(params.car2)) {
      return Left(
        ValidationFailure(
            'Le deuxième caractère doit être P, T, H ou Q (reçu: ${params.car2})'),
      );
    }
    if (!validChars.contains(params.carNeed)) {
      return Left(
        ValidationFailure(
            'Le caractère recherché doit être P, T, H ou Q (reçu: ${params.carNeed})'),
      );
    }

    // Validation que les caractères sont uniques
    if (params.car1 == params.car2) {
      return const Left(
        ValidationFailure(
            'Les deux caractères de recherche doivent être différents'),
      );
    }

    // Validation des valeurs
    if (!params.val1.isFinite || !params.val2.isFinite) {
      return const Left(
        ValidationFailure('Les valeurs doivent être des nombres valides'),
      );
    }

    // Délégation au repository
    return await repository.calculateAdvanced(
      fluid: params.fluid,
      car1: params.car1,
      val1: params.val1,
      car2: params.car2,
      val2: params.val2,
      carNeed: params.carNeed,
    );
  }
}

/// Paramètres pour le calcul avancé de règlette
class AdvancedRulerParams extends Equatable {
  final Fluid fluid;
  final String car1;
  final double val1;
  final String car2;
  final double val2;
  final String carNeed;

  const AdvancedRulerParams({
    required this.fluid,
    required this.car1,
    required this.val1,
    required this.car2,
    required this.val2,
    required this.carNeed,
  });

  @override
  List<Object> get props => [fluid, car1, val1, car2, val2, carNeed];
}
