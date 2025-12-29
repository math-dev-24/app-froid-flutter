import 'dart:convert';
import '../../domain/entities/fluid_custom.dart';

/// Modèle de données pour FluidCustom
///
/// Permet la sérialisation/désérialisation JSON
class FluidCustomModel extends FluidCustom {
  const FluidCustomModel({
    required super.label,
    required super.fluids,
    required super.fluidsRef,
    required super.quantities,
  });

  /// Crée une instance depuis une entité
  factory FluidCustomModel.fromEntity(FluidCustom entity) {
    return FluidCustomModel(
      label: entity.label,
      fluids: entity.fluids,
      fluidsRef: entity.fluidsRef,
      quantities: entity.quantities,
    );
  }

  /// Crée une instance depuis JSON
  factory FluidCustomModel.fromJson(Map<String, dynamic> json) {
    return FluidCustomModel(
      label: json['label'] as String,
      fluids: List<String>.from(json['fluids'] as List),
      fluidsRef: List<String>.from(json['fluidsRef'] as List),
      quantities: (json['quantities'] as List)
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  /// Convertit en JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'fluids': fluids,
      'fluidsRef': fluidsRef,
      'quantities': quantities,
    };
  }

  /// Convertit une liste de JSON en liste de models
  static List<FluidCustomModel> listFromJson(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList
        .map((json) => FluidCustomModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Convertit une liste de models en JSON string
  static String listToJson(List<FluidCustomModel> models) {
    final List<Map<String, dynamic>> jsonList =
        models.map((model) => model.toJson()).toList();
    return json.encode(jsonList);
  }
}
