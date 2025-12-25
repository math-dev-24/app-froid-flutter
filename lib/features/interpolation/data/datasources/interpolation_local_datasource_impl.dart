import 'dart:math';

import '../../domain/entities/interpolation_points.dart';
import '../models/interpolation_result_model.dart';
import 'interpolation_local_datasource.dart';

/// Implémentation de la source de données locale pour l'interpolation
class InterpolationLocalDataSourceImpl implements InterpolationLocalDataSource {
  @override
  InterpolationResultModel calculate(InterpolationPoints points) {
    // Formule d'interpolation linéaire: Y = Y₁ + (X - X₁) × (Y₂ - Y₁) / (X₂ - X₁)
    final y = points.y1 +
        (points.x - points.x1) * (points.y2 - points.y1) / (points.x2 - points.x1);

    // Vérifier si X est hors de la plage [X1, X2]
    final minX = min(points.x1, points.x2);
    final maxX = max(points.x1, points.x2);
    final isOutOfRange = points.x < minX || points.x > maxX;

    String? warningMessage;
    if (isOutOfRange) {
      warningMessage =
          'Attention : X = ${points.x.toStringAsFixed(2)} est hors de la plage [${minX.toStringAsFixed(2)}, ${maxX.toStringAsFixed(2)}]. '
          'Le résultat est une extrapolation.';
    }

    return InterpolationResultModel(
      y: y,
      isOutOfRange: isOutOfRange,
      warningMessage: warningMessage,
    );
  }
}
