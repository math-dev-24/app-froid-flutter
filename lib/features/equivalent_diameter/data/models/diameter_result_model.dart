import '../../domain/entities/diameter_result.dart';

/// Modèle de données pour le résultat de diamètre équivalent
class DiameterResultModel extends DiameterResult {
  const DiameterResultModel({
    required super.equivalentDiameter,
    required super.rectangularSection,
    required super.circularSection,
    required super.sectionRatioPercent,
  });

  factory DiameterResultModel.fromEntity(DiameterResult entity) {
    return DiameterResultModel(
      equivalentDiameter: entity.equivalentDiameter,
      rectangularSection: entity.rectangularSection,
      circularSection: entity.circularSection,
      sectionRatioPercent: entity.sectionRatioPercent,
    );
  }
}
