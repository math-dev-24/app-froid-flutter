import 'dart:async';
import '../../data/models/fluid.dart';
import '../../data/models/ruler_response.dart';
import '../api/api_service.dart';
import '../service_locator.dart';

/// Service legacy pour la règlette avancée
/// DEPRECATED: Utiliser les use cases de features/ruler/ pour le nouveau code
@Deprecated('Use CalculateAdvancedRuler use case instead')
class RulerService {
  final ApiService _apiService = getIt<ApiService>();
  Timer? _debounceTimer;
  final Duration debounceDuration;

  RulerService({this.debounceDuration = const Duration(milliseconds: 500)});

  Future<RulerResponse> calculateAdvanced({
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

      if (response['ok'] == false) {
        return RulerResponse.error(response['error'] ?? 'Erreur inconnue');
      }

      return RulerResponse.success(response);
    } catch (e) {
      return RulerResponse.error('Erreur: ${e.toString()}');
    }
  }

  void dispose() {
    _debounceTimer?.cancel();
  }
}
