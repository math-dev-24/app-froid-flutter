import '../../domain/entities/fluid.dart';

/// Modèle de données pour Fluid avec capacités de sérialisation
///
/// Hérite de l'entité du domaine et ajoute les méthodes de conversion JSON
class FluidModel extends Fluid {
  const FluidModel({
    required super.name,
    required super.refName,
    super.gwp,
    super.group,
    super.odp,
    super.classification,
    super.pCrit,
    super.pTriple,
    super.tCrit,
    super.tTriple,
    super.canSimulate,
    super.isMix,
    super.lfl,
    super.description,
    super.color,
    super.links,
    super.regulation,
  });

  /// Crée un FluidModel à partir d'une entité Fluid
  factory FluidModel.fromEntity(Fluid fluid) {
    return FluidModel(
      name: fluid.name,
      refName: fluid.refName,
      gwp: fluid.gwp,
      group: fluid.group,
      odp: fluid.odp,
      classification: fluid.classification,
      pCrit: fluid.pCrit,
      pTriple: fluid.pTriple,
      tCrit: fluid.tCrit,
      tTriple: fluid.tTriple,
      canSimulate: fluid.canSimulate,
      isMix: fluid.isMix,
      lfl: fluid.lfl,
      description: fluid.description,
      color: fluid.color,
      links: fluid.links,
      regulation: fluid.regulation,
    );
  }

  /// Crée un FluidModel à partir d'un JSON
  factory FluidModel.fromJson(Map<String, dynamic> json) {
    return FluidModel(
      name: json['name'] as String,
      refName: json['refName'] as String,
      gwp: json['gwp'] as int?,
      group: json['group'] as int?,
      odp: json['odp'] != null ? (json['odp'] as num).toDouble() : null,
      classification: json['classification'] as String?,
      pCrit: json['pCrit'] != null ? (json['pCrit'] as num).toDouble() : null,
      pTriple: json['pTriple'] != null ? (json['pTriple'] as num).toDouble() : null,
      tCrit: json['tCrit'] != null ? (json['tCrit'] as num).toDouble() : null,
      tTriple: json['tTriple'] != null ? (json['tTriple'] as num).toDouble() : null,
      canSimulate: json['canSimulate'] as bool? ?? true,
      isMix: json['isMix'] as bool? ?? false,
      description: json['description'] as String?,
      color: json['color'] as String?,
    );
  }

  /// Convertit le FluidModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'refName': refName,
      if (gwp != null) 'gwp': gwp,
      if (group != null) 'group': group,
      if (odp != null) 'odp': odp,
      if (classification != null) 'classification': classification,
      if (pCrit != null) 'pCrit': pCrit,
      if (pTriple != null) 'pTriple': pTriple,
      if (tCrit != null) 'tCrit': tCrit,
      if (tTriple != null) 'tTriple': tTriple,
      'canSimulate': canSimulate,
      'isMix': isMix,
      if (description != null) 'description': description,
      if (color != null) 'color': color,
    };
  }
}
