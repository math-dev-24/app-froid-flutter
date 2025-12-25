import '../../domain/entities/sensor_conversion_result.dart';

/// Modèle de données pour SensorConversionResult
class SensorConversionResultModel extends SensorConversionResult {
  const SensorConversionResultModel({
    required super.value,
    required super.unit,
    required super.description,
  });

  factory SensorConversionResultModel.fromEntity(
      SensorConversionResult result) {
    return SensorConversionResultModel(
      value: result.value,
      unit: result.unit,
      description: result.description,
    );
  }
}
