import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/calculation_result.dart';
import '../entities/fluid.dart';

/// Repository abstrait pour les calculs de règlette
///
/// Définit le contrat que doit respecter l'implémentation dans la couche data
/// Utilise Either de dartz pour la gestion des erreurs fonctionnelle
abstract class RulerRepository {
  /// Effectue un calcul simple de règlette
  ///
  /// Calcul basique: température -> pression ou pression -> température avec qualité = 1.0
  /// [fluid] Le fluide frigorigène à utiliser
  /// [temperature] La température en °C (optionnel si pressure est fourni)
  /// [pressure] La pression en bar (optionnel si temperature est fourni)
  ///
  /// Retourne Either un Failure ou le CalculationResult
  Future<Either<Failure, CalculationResult>> calculateSimple({
    required Fluid fluid,
    double? temperature,
    double? pressure,
  });

  /// Effectue un calcul avancé de règlette
  ///
  /// Permet de spécifier des paramètres personnalisés (P, T, H, Q)
  /// [fluid] Le fluide frigorigène à utiliser
  /// [car1] Premier caractère (P, T, H, Q)
  /// [val1] Première valeur
  /// [car2] Deuxième caractère (P, T, H, Q)
  /// [val2] Deuxième valeur
  /// [carNeed] Caractère recherché (P, T, H, Q)
  ///
  /// Retourne Either un Failure ou le CalculationResult
  Future<Either<Failure, CalculationResult>> calculateAdvanced({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  });
}
