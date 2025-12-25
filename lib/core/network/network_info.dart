/// Interface pour vérifier la connexion réseau
/// Permet d'abstraire la dépendance vers le package connectivity_plus
abstract class NetworkInfo {
  /// Vérifie si l'appareil est connecté à Internet
  Future<bool> get isConnected;
}
