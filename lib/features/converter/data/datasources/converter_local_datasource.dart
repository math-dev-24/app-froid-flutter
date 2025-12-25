import '../models/conversion_model.dart';

/// Source de données locale pour les conversions
///
/// Effectue les calculs de conversion côté client (pas d'API nécessaire)
abstract class ConverterLocalDataSource {
  /// Convertit une pression depuis une unité source
  List<ConversionModel> convertPressure({
    required double value,
    required String fromUnit,
  });

  /// Convertit une température depuis une unité source
  List<ConversionModel> convertTemperature({
    required double value,
    required String fromUnit,
  });
}
