/// Modèle de réponse pour les calculs de ruler
///
/// Représente le résultat d'un calcul avec gestion d'erreur structurée
class RulerResponse {
  final bool success;
  final Map<String, dynamic>? result;
  final String? error;

  RulerResponse._({
    required this.success,
    this.result,
    this.error,
  });

  /// Crée une réponse de succès avec le résultat du calcul
  factory RulerResponse.success(Map<String, dynamic> result) {
    return RulerResponse._(
      success: true,
      result: result,
    );
  }

  /// Crée une réponse d'erreur avec un message
  factory RulerResponse.error(String error) {
    return RulerResponse._(
      success: false,
      error: error,
    );
  }

  /// Récupère une valeur du résultat de manière sécurisée
  double? getValue(String key) {
    if (!success || result == null) return null;
    final value = result![key];
    if (value is num) return value.toDouble();
    return null;
  }

  /// Récupère toutes les valeurs sous forme de Map
  Map<String, double>? getAllValues() {
    if (!success || result == null) return null;
    return result!.map((key, value) {
      if (value is num) {
        return MapEntry(key, value.toDouble());
      }
      return MapEntry(key, 0.0);
    });
  }
}
