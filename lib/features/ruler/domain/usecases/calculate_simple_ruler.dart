import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculation_result.dart';
import '../entities/fluid.dart';
import '../repositories/ruler_repository.dart';

/// Use case pour effectuer un calcul simple de règlette
///
/// Transforme une température en pression pour un fluide donné
/// Utilise automatiquement Q=1.0 (vapeur saturée)
class CalculateSimpleRuler
    implements UseCase<CalculationResult, SimpleRulerParams> {
  final RulerRepository repository;

  CalculateSimpleRuler(this.repository);

  @override
  Future<Either<Failure, CalculationResult>> call(
      SimpleRulerParams params) async {
    // Validation des paramètres
    if (!params.temperature.isFinite) {
      return const Left(
        ValidationFailure('La température doit être un nombre valide'),
      );
    }

    // Délégation au repository
    return await repository.calculateSimple(
      fluid: params.fluid,
      temperature: params.temperature,
    );
  }
}

/// Paramètres pour le calcul simple de règlette
class SimpleRulerParams extends Equatable {
  final Fluid fluid;
  final double temperature;

  const SimpleRulerParams({
    required this.fluid,
    required this.temperature,
  });

  @override
  List<Object> get props => [fluid, temperature];
}
