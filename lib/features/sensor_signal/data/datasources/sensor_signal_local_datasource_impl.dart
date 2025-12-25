import '../../domain/entities/conversion_direction.dart';
import '../../domain/entities/signal_type.dart';
import '../models/sensor_conversion_result_model.dart';
import '../models/signal_type_model.dart';
import 'sensor_signal_local_datasource.dart';

/// Implémentation de la source de données locale pour les signaux
class SensorSignalLocalDataSourceImpl implements SensorSignalLocalDataSource {
  // Types de signaux disponibles
  static const List<SignalTypeModel> _signalTypes = [
    SignalTypeModel(
      min: 4,
      max: 20,
      delta: 16,
      unit: 'mA',
      label: '4 - 20 mA',
    ),
    SignalTypeModel(
      min: 0,
      max: 20,
      delta: 20,
      unit: 'mA',
      label: '0 - 20 mA',
    ),
    SignalTypeModel(
      min: 0,
      max: 10,
      delta: 10,
      unit: 'V',
      label: '0 - 10 V',
    ),
    SignalTypeModel(
      min: 1,
      max: 5,
      delta: 4,
      unit: 'V',
      label: '1 - 5 V',
    ),
  ];

  // Unités disponibles
  static const List<String> _units = [
    '°C', 'K', 'Pa', 'bar', 'F', 'A', 'W', 'kW',
    'V', 'mV', 'Hz', 'kHz', 's', 'ms', 'min', 'h',
    'd', 'mo', 'a', '%', 'm', 'mm', 'cm', 'km',
    'l/min', 'm³/h',
  ];

  @override
  SensorConversionResultModel convert({
    required SignalType signalType,
    required double minValue,
    required double maxValue,
    required String valueUnit,
    required double searchValue,
    required ConversionDirection direction,
  }) {
    if (direction == ConversionDirection.signalToValue) {
      // Signal → Valeur
      final pasSignal = (maxValue - minValue) / signalType.delta;
      final calculatedValue =
          (pasSignal * (searchValue - signalType.min) + minValue);

      return SensorConversionResultModel(
        value: calculatedValue,
        unit: valueUnit,
        description:
            'Pour un signal de ${searchValue.toStringAsFixed(2)} ${signalType.unit}, la valeur mesurée est :',
      );
    } else {
      // Valeur → Signal
      final pasValeur = signalType.delta / (maxValue - minValue);
      final calculatedSignal =
          (pasValeur * (searchValue - minValue)) + signalType.min;

      return SensorConversionResultModel(
        value: calculatedSignal,
        unit: signalType.unit,
        description:
            'Pour une valeur de ${searchValue.toStringAsFixed(2)} $valueUnit, le signal de sortie est :',
      );
    }
  }

  @override
  List<SignalTypeModel> getAvailableSignalTypes() => _signalTypes;

  @override
  List<String> getAvailableUnits() => _units;
}
