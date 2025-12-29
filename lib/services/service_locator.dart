import 'package:get_it/get_it.dart';
import 'api/api_service.dart';

/// Instance globale du service locator
final getIt = GetIt.instance;

/// Configure tous les services de l'application
///
/// Cette fonction doit être appelée une seule fois au démarrage de l'app
/// dans la fonction main() avant runApp()
void setupServiceLocator() {
  // Enregistre les services en tant que singletons

  // Service API - Client HTTP pour communiquer avec le backend
  getIt.registerLazySingleton<ApiService>(() => ApiService());
}
