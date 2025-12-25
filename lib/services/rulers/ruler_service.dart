import 'dart:async';
import '../../data/models/fluid.dart';
import '../../data/models/ruler_response.dart';
import '../api/api_service.dart';

/// Service métier pour les calculs de règlette
///
/// Gère la logique métier des calculs, le debouncing, la validation
/// et la transformation des réponses de l'API
class RulerService {
  final ApiService _apiService;
  Timer? _debounceTimer;

  RulerService({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  /// Nettoie les ressources (timers) utilisées par le service
  void dispose() {
    _debounceTimer?.cancel();
  }

  /// Calcule une règlette simple (T -> P avec Q=1.0)
  ///
  /// Cette méthode utilise un debouncing de 500ms pour éviter
  /// trop d'appels API lors de changements rapides de valeurs
  Future<RulerResponse> calculateSimple({
    required Fluid fluid,
    required double temperature,
    Duration debounceDuration = const Duration(milliseconds: 500),
  }) async {
    // Annule le timer précédent si existant
    _debounceTimer?.cancel();

    // Crée un Completer pour retourner le résultat après le debounce
    final completer = Completer<RulerResponse>();

    _debounceTimer = Timer(debounceDuration, () async {
      final response = await _calculateRuler(
        fluid: fluid,
        car1: 'T',
        val1: temperature,
        car2: 'Q',
        val2: 1.0,
        carNeed: 'P',
      );
      completer.complete(response);
    });

    return completer.future;
  }

  /// Calcule une règlette avancée avec paramètres personnalisés
  Future<RulerResponse> calculateAdvanced({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    return await _calculateRuler(
      fluid: fluid,
      car1: car1,
      val1: val1,
      car2: car2,
      val2: val2,
      carNeed: carNeed,
    );
  }

  /// Méthode privée pour effectuer l'appel API et transformer la réponse
  Future<RulerResponse> _calculateRuler({
    required Fluid fluid,
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) async {
    try {
      final response = await _apiService.ruler(
        fluid: fluid.refName,
        car1: car1,
        val1: val1,
        car2: car2,
        val2: val2,
        carNeed: carNeed,
      );

      // Vérifie si la réponse est un succès
      if (response['ok'] == true) {
        return RulerResponse.success(response);
      } else {
        // Gère les erreurs retournées par l'API
        final errorMessage = response['error'] ?? 'Erreur inconnue';
        return RulerResponse.error(errorMessage);
      }
    } catch (e) {
      // Gère les erreurs inattendues
      return RulerResponse.error('Erreur lors du calcul: ${e.toString()}');
    }
  }

  /// Valide les paramètres avant un calcul
  bool validateParameters({
    required String car1,
    required double val1,
    required String car2,
    required double val2,
    required String carNeed,
  }) {
    // Vérifie que les caractéristiques sont valides
    final validCars = ['P', 'T', 'H', 'Q'];
    if (!validCars.contains(car1) ||
        !validCars.contains(car2) ||
        !validCars.contains(carNeed)) {
      return false;
    }

    // Vérifie que car1 et car2 sont différents
    if (car1 == car2) {
      return false;
    }

    // Vérifie que les valeurs sont valides (non infinies, non NaN)
    if (!val1.isFinite || !val2.isFinite) {
      return false;
    }

    return true;
  }
}
