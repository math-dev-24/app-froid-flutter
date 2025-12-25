import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversion.dart';

/// Repository pour les conversions d'unités
///
/// Fournit des méthodes pour convertir les pressions et températures
abstract class ConverterRepository {
  /// Convertit une pression depuis une unité source
  ///
  /// [value] La valeur à convertir
  /// [fromUnit] L'unité source ('bar', 'MPa', 'PSI', 'mce')
  ///
  /// Retourne Either un Failure ou une liste de conversions
  Either<Failure, List<Conversion>> convertPressure({
    required double value,
    required String fromUnit,
  });

  /// Convertit une température depuis une unité source
  ///
  /// [value] La valeur à convertir
  /// [fromUnit] L'unité source ('K', '°C', '°F')
  ///
  /// Retourne Either un Failure ou une liste de conversions
  Either<Failure, List<Conversion>> convertTemperature({
    required double value,
    required String fromUnit,
  });
}
