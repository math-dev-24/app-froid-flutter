import '../../domain/entities/interpolation_points.dart';
import '../models/interpolation_result_model.dart';

/// Interface de la source de données locale pour l'interpolation
abstract class InterpolationLocalDataSource {
  InterpolationResultModel calculate(InterpolationPoints points);
}
