import '../../domain/entities/desp_parameters.dart';
import '../models/desp_result_model.dart';

/// Interface de la source de données locale pour DESP
abstract class DespLocalDataSource {
  DespResultModel calculate(DespParameters parameters);
}
