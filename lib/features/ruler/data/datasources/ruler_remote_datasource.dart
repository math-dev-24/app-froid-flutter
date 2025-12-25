import '../models/calculation_result_model.dart';

/// Interface abstraite pour la source de données distante (API)
///
/// Définit le contrat pour communiquer avec l'API de calcul thermodynamique
abstract class RulerRemoteDataSource {
  /// Effectue un calcul via l'API
  ///
  /// Lance une [ServerException] en cas d'erreur serveur
  /// Lance une [NetworkException] en cas d'absence de réseau
  /// Lance une [ParsingException] si la réponse est invalide
  Future<CalculationResultModel> calculate({
    required String fluidRefName,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  });
}
