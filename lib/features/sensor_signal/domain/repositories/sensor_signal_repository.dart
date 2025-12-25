import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/conversion_direction.dart';
import '../entities/sensor_conversion_result.dart';
import '../entities/signal_type.dart';

/// Repository pour les conversions de signaux de capteurs
abstract class SensorSignalRepository {
  /// Convertit un signal ou une valeur
  ///
  /// [signalType] Le type de signal électrique
  /// [minValue] Valeur minimale de l'échelle
  /// [maxValue] Valeur maximale de l'échelle
  /// [valueUnit] Unité de la valeur mesurée
  /// [searchValue] La valeur à convertir
  /// [direction] Direction de conversion (signal→valeur ou valeur→signal)
  ///
  /// Retourne Either un Failure ou le résultat de conversion
  Either<Failure, SensorConversionResult> convert({
    required SignalType signalType,
    required double minValue,
    required double maxValue,
    required String valueUnit,
    required double searchValue,
    required ConversionDirection direction,
  });

  /// Récupère la liste des types de signaux disponibles
  List<SignalType> getAvailableSignalTypes();

  /// Récupère la liste des unités disponibles
  List<String> getAvailableUnits();
}
