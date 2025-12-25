import 'package:equatable/equatable.dart';

import 'variation_significance.dart';

/// Entité représentant le résultat d'un test d'azote
class TestResult extends Equatable {
  final double finalPressure;
  final double pressureDifference;
  final double pressureVariationPercent;
  final double initialTemperatureKelvin;
  final double finalTemperatureKelvin;
  final String temperatureChange;
  final VariationSignificance significance;

  const TestResult({
    required this.finalPressure,
    required this.pressureDifference,
    required this.pressureVariationPercent,
    required this.initialTemperatureKelvin,
    required this.finalTemperatureKelvin,
    required this.temperatureChange,
    required this.significance,
  });

  @override
  List<Object> get props => [
        finalPressure,
        pressureDifference,
        pressureVariationPercent,
        initialTemperatureKelvin,
        finalTemperatureKelvin,
        temperatureChange,
        significance,
      ];
}
