import 'models/fluid.dart';

/// Liste statique des fluides frigorigènes disponibles
class ListFluids {
  static const List<Fluid> fluids = [
    Fluid(
      name: 'R22',
      refName: "R22",
      pCrit: 49.9,
      pTriple: -1,
      tCrit: 96.15,
      tTriple: -157.42
    ),
    Fluid(
      name: 'R134a',
      refName: 'R134a.fld',
      pCrit: 40.59,
      pTriple: -1,
      tCrit: 101.06,
      tTriple: -103.3
      )
  ];

  static Fluid? getFluidbyRefName(String refName) {
    try {
      return fluids.firstWhere((f) => f.refName == refName);
    } catch (e) {
      return null;
    }
  }

  static Fluid? getFluidByName(String name) {
    try {
      return fluids.firstWhere((f) => f.name == name);
    } catch(e) {
      return null;
    }
  }

  static bool existFluid(Fluid fluid) {
    return fluids.any((f) => f.refName == fluid.refName);
  }
}
