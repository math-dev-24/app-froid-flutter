import '../../domain/entities/conversion_direction.dart';
import '../../domain/entities/signal_type.dart';
import '../models/sensor_conversion_result_model.dart';
import '../models/signal_type_model.dart';

/// Source de données locale pour les signaux de capteurs
abstract class SensorSignalLocalDataSource {
  /// Convertit un signal ou une valeur
  SensorConversionResultModel convert({
    required SignalType signalType,
    required double minValue,
    required double maxValue,
    required String valueUnit,
    required double searchValue,
    required ConversionDirection direction,
  });

  /// Récupère la liste des types de signaux disponibles
  List<SignalTypeModel> getAvailableSignalTypes();

  /// Récupère la liste des unités disponibles
  List<String> getAvailableUnits();
}
