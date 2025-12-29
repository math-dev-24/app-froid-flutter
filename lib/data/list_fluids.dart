// DEPRECATED: Utilisez FluidsLocalData à la place
// Ce fichier est conservé pour compatibilité temporaire
import 'package:app_froid/features/ruler/data/datasources/fluids_local_data.dart';
import 'package:app_froid/features/ruler/domain/entities/fluid.dart';

export 'package:app_froid/features/ruler/data/datasources/fluids_local_data.dart';

/// Liste statique des fluides frigorigènes disponibles
///
/// DEPRECATED: Cette classe est obsolète.
/// Utilisez FluidsLocalData à la place qui contient les 59 fluides complets.
class ListFluids {
  /// DEPRECATED: Utilisez FluidsLocalData.fluids
  static List<Fluid> get fluids => FluidsLocalData.fluids;

  /// DEPRECATED: Utilisez FluidsLocalData.getFluidByRefName
  static Fluid? getFluidbyRefName(String refName) {
    return FluidsLocalData.getFluidByRefName(refName);
  }

  /// DEPRECATED: Utilisez FluidsLocalData.getFluidByName
  static Fluid? getFluidByName(String name) {
    return FluidsLocalData.getFluidByName(name);
  }

  /// DEPRECATED: Utilisez FluidsLocalData.existFluid
  static bool existFluid(Fluid fluid) {
    return FluidsLocalData.existFluid(fluid);
  }
}
