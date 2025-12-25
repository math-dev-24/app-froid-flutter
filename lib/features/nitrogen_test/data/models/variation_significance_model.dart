import '../../domain/entities/variation_significance.dart';

/// Modèle de données pour la signification d'une variation
class VariationSignificanceModel extends VariationSignificance {
  const VariationSignificanceModel({
    required super.status,
    required super.message,
  });

  factory VariationSignificanceModel.fromEntity(VariationSignificance entity) {
    return VariationSignificanceModel(
      status: entity.status,
      message: entity.message,
    );
  }
}
