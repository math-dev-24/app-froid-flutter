import '../../domain/entities/interpolation_result.dart';

/// Modèle de données pour le résultat d'interpolation
class InterpolationResultModel extends InterpolationResult {
  const InterpolationResultModel({
    required super.y,
    required super.isOutOfRange,
    super.warningMessage,
  });

  factory InterpolationResultModel.fromEntity(InterpolationResult entity) {
    return InterpolationResultModel(
      y: entity.y,
      isOutOfRange: entity.isOutOfRange,
      warningMessage: entity.warningMessage,
    );
  }
}
