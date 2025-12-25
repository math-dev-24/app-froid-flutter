import 'package:equatable/equatable.dart';

/// Entité représentant le résultat d'un calcul thermodynamique
///
/// Contient les valeurs calculées pour les propriétés du fluide
class CalculationResult extends Equatable {
  final Map<String, double> values;

  const CalculationResult({required this.values});

  /// Récupère une valeur spécifique du résultat
  double? getValue(String key) => values[key];

  /// Vérifie si une clé existe dans le résultat
  bool hasValue(String key) => values.containsKey(key);

  /// Retourne toutes les clés disponibles
  List<String> get keys => values.keys.toList();

  @override
  List<Object?> get props => [values];

  @override
  String toString() => 'CalculationResult(values: $values)';
}
