import '../../domain/entities/test_parameters.dart';
import '../../domain/entities/variation_significance.dart';
import '../models/test_result_model.dart';
import '../models/variation_significance_model.dart';
import 'nitrogen_test_local_datasource.dart';

/// Implémentation de la source de données locale pour le test d'azote
class NitrogenTestLocalDataSourceImpl implements NitrogenTestLocalDataSource {
  @override
  TestResultModel calculate(TestParameters parameters) {
    // Convertir les températures en Kelvin
    final tInitKelvin = parameters.initialTemperature + 273.15;
    final tFinalKelvin = parameters.finalTemperature + 273.15;

    // Calcul de la pression finale selon la loi des gaz parfaits (P1/T1 = P2/T2)
    // P2 = P1 × (T2/T1)
    final finalPressure = (parameters.initialPressure * tFinalKelvin / tInitKelvin * 1000).round() / 1000;

    // Différence de pression
    final pressureDifference = ((finalPressure - parameters.initialPressure) * 1000).round() / 1000;

    // Pourcentage de variation
    final pressureVariationPercent = parameters.initialPressure == 0
        ? 0.0
        : ((pressureDifference / parameters.initialPressure) * 100 * 10).round() / 10;

    // Déterminer le changement de température
    final temperatureChange = parameters.finalTemperature > parameters.initialTemperature
        ? 'Chauffage'
        : parameters.finalTemperature < parameters.initialTemperature
            ? 'Refroidissement'
            : 'Stable';

    // Déterminer la signification de la variation
    final absPercent = pressureVariationPercent.abs();
    final VariationSignificanceModel significance;

    if (absPercent < 2) {
      significance = const VariationSignificanceModel(
        status: VariationStatus.success,
        message: 'Variation négligeable',
      );
    } else if (absPercent < 5) {
      significance = const VariationSignificanceModel(
        status: VariationStatus.warning,
        message: 'Variation modérée',
      );
    } else {
      significance = const VariationSignificanceModel(
        status: VariationStatus.error,
        message: 'Variation significative',
      );
    }

    return TestResultModel(
      finalPressure: finalPressure,
      pressureDifference: pressureDifference,
      pressureVariationPercent: pressureVariationPercent,
      initialTemperatureKelvin: tInitKelvin,
      finalTemperatureKelvin: tFinalKelvin,
      temperatureChange: temperatureChange,
      significance: significance,
    );
  }
}
