import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/conversion.dart';
import '../repositories/converter_repository.dart';

/// Use case pour convertir une température
class ConvertTemperature implements UseCase<List<Conversion>, ConvertTemperatureParams> {
  final ConverterRepository repository;

  ConvertTemperature(this.repository);

  @override
  Future<Either<Failure, List<Conversion>>> call(ConvertTemperatureParams params) async {
    // Validation de la valeur
    if (!params.value.isFinite) {
      return const Left(
        ValidationFailure('La valeur doit être un nombre valide'),
      );
    }

    // Validation de l'unité
    const validUnits = ['K', '°C', '°F'];
    if (!validUnits.contains(params.fromUnit)) {
      return Left(
        ValidationFailure('Unité non valide: ${params.fromUnit}'),
      );
    }

    // Délégation au repository
    return repository.convertTemperature(
      value: params.value,
      fromUnit: params.fromUnit,
    );
  }
}

/// Paramètres pour la conversion de température
class ConvertTemperatureParams extends Equatable {
  final double value;
  final String fromUnit;

  const ConvertTemperatureParams({
    required this.value,
    required this.fromUnit,
  });

  @override
  List<Object> get props => [value, fromUnit];
}
