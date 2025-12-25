import '../../domain/entities/fluid.dart';

/// Modèle de données pour Fluid avec capacités de sérialisation
///
/// Hérite de l'entité du domaine et ajoute les méthodes de conversion JSON
class FluidModel extends Fluid {
  const FluidModel({
    required super.name,
    required super.refName,
    super.group,
    super.classification,
    super.pCrit,
    super.pTriple,
    super.tCrit,
    super.tTriple,
  });

  /// Crée un FluidModel à partir d'une entité Fluid
  factory FluidModel.fromEntity(Fluid fluid) {
    return FluidModel(
      name: fluid.name,
      refName: fluid.refName,
      group: fluid.group,
      classification: fluid.classification,
      pCrit: fluid.pCrit,
      pTriple: fluid.pTriple,
      tCrit: fluid.tCrit,
      tTriple: fluid.tTriple,
    );
  }

  /// Crée un FluidModel à partir d'un JSON
  factory FluidModel.fromJson(Map<String, dynamic> json) {
    return FluidModel(
      name: json['name'] as String,
      refName: json['refName'] as String,
      group: json['group'] as String?,
      classification: json['classification'] as String?,
      pCrit: json['pCrit'] != null ? (json['pCrit'] as num).toDouble() : null,
      pTriple:
          json['pTriple'] != null ? (json['pTriple'] as num).toDouble() : null,
      tCrit: json['tCrit'] != null ? (json['tCrit'] as num).toDouble() : null,
      tTriple:
          json['tTriple'] != null ? (json['tTriple'] as num).toDouble() : null,
    );
  }

  /// Convertit le FluidModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'refName': refName,
      if (group != null) 'group': group,
      if (classification != null) 'classification': classification,
      if (pCrit != null) 'pCrit': pCrit,
      if (pTriple != null) 'pTriple': pTriple,
      if (tCrit != null) 'tCrit': tCrit,
      if (tTriple != null) 'tTriple': tTriple,
    };
  }
}
