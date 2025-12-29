import 'package:equatable/equatable.dart';

/// Limites d'inflammabilité (Lower Flammability Limit)
class LflLimits extends Equatable {
  final double lower;
  final double upper;

  const LflLimits({
    required this.lower,
    required this.upper,
  });

  @override
  List<Object?> get props => [lower, upper];
}

/// Lien vers ressource externe
class FluidLink extends Equatable {
  final String label;
  final String url;

  const FluidLink({
    required this.label,
    required this.url,
  });

  @override
  List<Object?> get props => [label, url];
}

/// Réglementation applicable au fluide
class FluidRegulation extends Equatable {
  final bool affected;
  final String? limitYear;
  final String? about;

  const FluidRegulation({
    required this.affected,
    this.limitYear,
    this.about,
  });

  @override
  List<Object?> get props => [affected, limitYear, about];
}

/// Entité représentant un fluide frigorigène dans le domaine métier
///
/// Cette classe est immuable et ne dépend d'aucune librairie externe
/// (sauf Equatable pour la comparaison)
class Fluid extends Equatable {
  final String name;
  final String refName;
  final int? gwp;
  final int? group;
  final double? odp;
  final String? classification;
  final double? pCrit; // critical_pres
  final double? pTriple; // triple_pres
  final double? tCrit; // critical_temp
  final double? tTriple; // triple_temp
  final bool canSimulate;
  final bool isMix;
  final LflLimits? lfl;
  final String? description;
  final String? color;
  final List<FluidLink> links;
  final FluidRegulation? regulation;

  const Fluid({
    required this.name,
    required this.refName,
    this.gwp,
    this.group,
    this.odp,
    this.classification,
    this.pCrit,
    this.pTriple,
    this.tCrit,
    this.tTriple,
    this.canSimulate = true,
    this.isMix = false,
    this.lfl,
    this.description,
    this.color,
    this.links = const [],
    this.regulation,
  });

  @override
  List<Object?> get props => [
        name,
        refName,
        gwp,
        group,
        odp,
        classification,
        pCrit,
        pTriple,
        tCrit,
        tTriple,
        canSimulate,
        isMix,
        lfl,
        description,
        color,
        links,
        regulation,
      ];
}
