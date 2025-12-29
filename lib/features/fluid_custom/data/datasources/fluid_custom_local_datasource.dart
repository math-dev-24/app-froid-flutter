import '../models/fluid_custom_model.dart';

/// Interface pour la source de données locale des fluides personnalisés
abstract class FluidCustomLocalDataSource {
  /// Récupère tous les fluides personnalisés
  Future<List<FluidCustomModel>> getFluidCustoms();

  /// Sauvegarde la liste des fluides personnalisés
  Future<void> saveFluidCustoms(List<FluidCustomModel> fluids);

  /// Ajoute un nouveau fluide personnalisé
  Future<void> addFluidCustom(FluidCustomModel fluid);

  /// Met à jour un fluide personnalisé
  Future<void> updateFluidCustom(int index, FluidCustomModel fluid);

  /// Supprime un fluide personnalisé
  Future<void> removeFluidCustom(int index);
}
