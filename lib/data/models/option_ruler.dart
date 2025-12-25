/// Modèle représentant une option de calcul pour la règlette
class OptionRuler {
  final String label;
  final String value;
  final bool canSearch;

  const OptionRuler({
    required this.label,
    required this.value,
    required this.canSearch
  });

  @override
  bool operator ==(Object other) =>
  identical(this, other) ||
  other is OptionRuler  && value == other.value;

  @override
  int get hashCode => value.hashCode;
}
