import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/fluid_custom.dart';

/// Repository pour la gestion des fluides personnalisés
abstract class FluidCustomRepository {
  /// Récupère tous les fluides personnalisés
  Future<Either<Failure, List<FluidCustom>>> getFluidCustoms();

  /// Sauvegarde la liste des fluides personnalisés
  Future<Either<Failure, void>> saveFluidCustoms(List<FluidCustom> fluids);

  /// Ajoute un nouveau fluide personnalisé
  Future<Either<Failure, void>> addFluidCustom(FluidCustom fluid);

  /// Met à jour un fluide personnalisé
  Future<Either<Failure, void>> updateFluidCustom(int index, FluidCustom fluid);

  /// Supprime un fluide personnalisé
  Future<Either<Failure, void>> removeFluidCustom(int index);
}
