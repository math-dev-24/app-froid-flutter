import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversion.dart';
import '../repositories/converter_repository.dart';

/// Use case pour convertir une pression
class ConvertPressure implements UseCase<List<Conversion>, ConvertPressureParams> {
  final ConverterRepository repository;

  ConvertPressure(this.repository);

  @override
  Future<Either<Failure, List<Conversion>>> call(ConvertPressureParams params) async {
    // Validation de la valeur
    if (!params.value.isFinite) {
      return const Left(
        ValidationFailure('La valeur doit être un nombre valide'),
      );
    }

    // Validation de l'unité
    const validUnits = ['bar', 'MPa', 'PSI', 'mce'];
    if (!validUnits.contains(params.fromUnit)) {
      return Left(
        ValidationFailure('Unité non valide: ${params.fromUnit}'),
      );
    }

    // Délégation au repository
    return repository.convertPressure(
      value: params.value,
      fromUnit: params.fromUnit,
    );
  }
}

/// Paramètres pour la conversion de pression
class ConvertPressureParams extends Equatable {
  final double value;
  final String fromUnit;

  const ConvertPressureParams({
    required this.value,
    required this.fromUnit,
  });

  @override
  List<Object> get props => [value, fromUnit];
}
