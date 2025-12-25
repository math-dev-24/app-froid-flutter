import '../../domain/entities/desp_result.dart';

/// Modèle de données pour le résultat DESP
class DespResultModel extends DespResult {
  const DespResultModel({
    required super.category,
    required super.description,
    required super.pvValue,
    required super.pvUnit,
  });

  factory DespResultModel.fromEntity(DespResult entity) {
    return DespResultModel(
      category: entity.category,
      description: entity.description,
      pvValue: entity.pvValue,
      pvUnit: entity.pvUnit,
    );
  }
}
