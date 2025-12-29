import 'package:app_froid/features/intermediate_pressure/domain/entities/pressure_result.dart';

class PressureResultModel extends PressureResult {
  const PressureResultModel({
    required super.intermediateEqualEfficiency,
    required super.intermediateSandHold,
    required super.compressionRatioHPEqual,
    required super.compressionRatioBPEqual,
    required super.compressionRatioHPSandHold,
    required super.compressionRatioBPSandHold,
  });

  factory PressureResultModel.fromEntity(PressureResult entity) {
    return PressureResultModel(
      intermediateEqualEfficiency: entity.intermediateEqualEfficiency,
      intermediateSandHold: entity.intermediateSandHold,
      compressionRatioHPEqual: entity.compressionRatioHPEqual,
      compressionRatioBPEqual: entity.compressionRatioBPEqual,
      compressionRatioHPSandHold: entity.compressionRatioHPSandHold,
      compressionRatioBPSandHold: entity.compressionRatioBPSandHold,
    );
  }
}
