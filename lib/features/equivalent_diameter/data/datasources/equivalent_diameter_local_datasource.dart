import '../../domain/entities/duct_dimensions.dart';
import '../models/diameter_result_model.dart';

/// Interface de la source de données locale pour le diamètre équivalent
abstract class EquivalentDiameterLocalDataSource {
  DiameterResultModel calculate(DuctDimensions dimensions);
}
