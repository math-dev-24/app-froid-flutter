import '../../domain/entities/fluid.dart';

/// Source de données locale pour les fluides frigorigènes
///
/// Fournit une liste statique des fluides disponibles
class FluidsLocalData {
  static const List<Fluid> fluids = [
    Fluid(
      name: 'R22',
      refName: "R22",
      pCrit: 49.9,
      pTriple: -1,
      tCrit: 96.15,
      tTriple: -157.42,
    ),
    Fluid(
      name: 'R134a',
      refName: 'R134a.fld',
      pCrit: 40.59,
      pTriple: -1,
      tCrit: 101.06,
      tTriple: -103.3,
    ),
  ];

  /// Récupère un fluide par son refName
  static Fluid? getFluidByRefName(String refName) {
    try {
      return fluids.firstWhere((f) => f.refName == refName);
    } catch (e) {
      return null;
    }
  }

  /// Récupère un fluide par son nom
  static Fluid? getFluidByName(String name) {
    try {
      return fluids.firstWhere((f) => f.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si un fluide existe
  static bool existFluid(Fluid fluid) {
    return fluids.any((f) => f.refName == fluid.refName);
  }
}
