/// Modèle représentant un fluide frigorigène
class Fluid {
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
    this.tTriple
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Fluid &&
          runtimeType == other.runtimeType &&
          refName == other.refName;

  @override
  int get hashCode => refName.hashCode;
}
