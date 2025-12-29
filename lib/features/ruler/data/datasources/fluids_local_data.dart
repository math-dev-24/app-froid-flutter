import '../../domain/entities/fluid.dart';
import 'fluids_complete_data.dart';
export 'fluids_complete_data.dart';

/// Source de données locale pour les fluides frigorigènes
///
/// Fournit une liste statique des fluides disponibles
/// Cette classe est un alias vers FluidsCompleteData pour compatibilité
class FluidsLocalData {
  /// Liste de tous les fluides disponibles
  static List<Fluid> get fluids => FluidsCompleteData.fluids;

  /// Récupère un fluide par son refName
  static Fluid? getFluidByRefName(String refName) {
    return FluidsCompleteData.getFluidByRefName(refName);
  }

  /// Récupère un fluide par son nom
  static Fluid? getFluidByName(String name) {
    return FluidsCompleteData.getFluidByName(name);
  }

  /// Vérifie si un fluide existe
  static bool existFluid(Fluid fluid) {
    return FluidsCompleteData.existFluid(fluid);
  }

  /// Filtre les fluides par classification
  static List<Fluid> getFluidsByClassification(String? classification) {
    if (classification == null) return fluids;
    return fluids.where((f) => f.classification == classification).toList();
  }

  /// Filtre les fluides par groupe
  static List<Fluid> getFluidsByGroup(int? group) {
    if (group == null) return fluids;
    return fluids.where((f) => f.group == group).toList();
  }
}
