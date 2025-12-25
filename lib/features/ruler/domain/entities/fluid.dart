import 'package:equatable/equatable.dart';

/// Entité représentant un fluide frigorigène dans le domaine métier
///
/// Cette classe est immuable et ne dépend d'aucune librairie externe
/// (sauf Equatable pour la comparaison)
class Fluid extends Equatable {
  final String name;
  final String refName;
  final String? group;
  final String? classification;
  final double? pCrit;
  final double? pTriple;
  final double? tCrit;
  final double? tTriple;

  const Fluid({
    required this.name,
    required this.refName,
    this.group,
    this.classification,
    this.pCrit,
    this.pTriple,
    this.tCrit,
    this.tTriple,
  });

  @override
  List<Object?> get props => [
        name,
        refName,
        group,
        classification,
        pCrit,
        pTriple,
        tCrit,
        tTriple,
      ];
}
