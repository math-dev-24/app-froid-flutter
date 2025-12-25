import 'package:get_it/get_it.dart';
import 'api/api_service.dart';
import 'rulers/ruler_service.dart';
import 'counter_service.dart';

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

  // Service Ruler - Logique métier pour les calculs de règlette
  getIt.registerLazySingleton<RulerService>(
    () => RulerService(apiService: getIt<ApiService>()),
  );

  // Service Counter - Gestion du compteur persistant
  getIt.registerLazySingleton<CounterService>(() => CounterService());
}

/// Nettoie les services avant de fermer l'application
void disposeServices() {
  getIt<RulerService>().dispose();
  getIt.reset();
}
