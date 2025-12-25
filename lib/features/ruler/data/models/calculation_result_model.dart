import '../../domain/entities/calculation_result.dart';

/// Modèle de données pour CalculationResult avec capacités de sérialisation
///
/// Hérite de l'entité du domaine et ajoute les méthodes de conversion JSON
class CalculationResultModel extends CalculationResult {
  const CalculationResultModel({required super.values});

  /// Crée un CalculationResultModel à partir d'une entité CalculationResult
  factory CalculationResultModel.fromEntity(CalculationResult result) {
    return CalculationResultModel(values: result.values);
  }

  /// Crée un CalculationResultModel à partir d'un JSON
  ///
  /// Convertit tous les nombres en double pour uniformiser les types
  factory CalculationResultModel.fromJson(Map<String, dynamic> json) {
    final Map<String, double> convertedValues = {};

    json.forEach((key, value) {
      if (value is num) {
        convertedValues[key] = value.toDouble();
      } else if (value is String) {
        // Tentative de parsing si c'est une chaîne
        final parsed = double.tryParse(value);
        if (parsed != null) {
          convertedValues[key] = parsed;
        }
      }
    });

    return CalculationResultModel(values: convertedValues);
  }

  /// Convertit le CalculationResultModel en JSON
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(values);
  }
}
