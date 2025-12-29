import 'dart:math';
import 'package:app_froid/core/error/exceptions.dart';
import 'package:app_froid/features/intermediate_pressure/data/datasources/intermediate_pressure_local_datasource.dart';
import 'package:app_froid/features/intermediate_pressure/data/models/pressure_result_model.dart';
import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_parameters.dart';

class IntermediatePressureLocalDataSourceImpl
    implements IntermediatePressureLocalDataSource {
  @override
  Future<PressureResultModel> calculateIntermediatePressure(
    PressureParameters parameters,
  ) async {
    try {
      final highPressure = parameters.highPressure;
      final lowPressure = parameters.lowPressure;

      if (lowPressure >= highPressure) {
        throw const CalculationException(
          "La pression d'évaporation doit être inférieure à la pression de condensation",
        );
      }

      if (highPressure <= 0) {
        throw const CalculationException(
          "La pression de condensation doit être supérieure à 0",
        );
      }

      if (lowPressure < -1) {
        throw const CalculationException(
          "Erreur dans les données d'entrées",
        );
      }

      // Méthode égalité des rendements
      final intermediateEqualEfficiency =
          ((sqrt(highPressure * lowPressure)) * 100).round() / 100;

      // Méthode Sand Hold
      final intermediateSandHold =
          ((intermediateEqualEfficiency + 0.35) * 100).round() / 100;

      // Rapport de compression HP (égalité)
      final compressionRatioHPEqual =
          ((highPressure / intermediateEqualEfficiency) * 100).round() / 100;

      // Rapport de compression BP (égalité)
      final compressionRatioBPEqual =
          ((intermediateEqualEfficiency / lowPressure) * 100).round() / 100;

      // Rapport de compression HP (Sand Hold)
      final compressionRatioHPSandHold =
          ((highPressure / intermediateSandHold) * 100).round() / 100;

      // Rapport de compression BP (Sand Hold)
      final compressionRatioBPSandHold =
          ((intermediateSandHold / lowPressure) * 100).round() / 100;

      return PressureResultModel(
        intermediateEqualEfficiency: intermediateEqualEfficiency,
        intermediateSandHold: intermediateSandHold,
        compressionRatioHPEqual: compressionRatioHPEqual,
        compressionRatioBPEqual: compressionRatioBPEqual,
        compressionRatioHPSandHold: compressionRatioHPSandHold,
        compressionRatioBPSandHold: compressionRatioBPSandHold,
      );
    } catch (e) {
      if (e is CalculationException) {
        rethrow;
      }
      throw CalculationException(e.toString());
    }
  }
}
