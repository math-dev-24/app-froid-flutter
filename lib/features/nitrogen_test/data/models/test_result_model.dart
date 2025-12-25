import '../../domain/entities/test_result.dart';

/// Modèle de données pour le résultat d'un test d'azote
class TestResultModel extends TestResult {
  const TestResultModel({
    required super.finalPressure,
    required super.pressureDifference,
    required super.pressureVariationPercent,
    required super.initialTemperatureKelvin,
    required super.finalTemperatureKelvin,
    required super.temperatureChange,
    required super.significance,
  });

  factory TestResultModel.fromEntity(TestResult entity) {
    return TestResultModel(
      finalPressure: entity.finalPressure,
      pressureDifference: entity.pressureDifference,
      pressureVariationPercent: entity.pressureVariationPercent,
      initialTemperatureKelvin: entity.initialTemperatureKelvin,
      finalTemperatureKelvin: entity.finalTemperatureKelvin,
      temperatureChange: entity.temperatureChange,
      significance: entity.significance,
    );
  }
}
