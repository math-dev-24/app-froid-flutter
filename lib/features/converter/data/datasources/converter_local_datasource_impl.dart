import '../models/conversion_model.dart';
import 'converter_local_datasource.dart';

/// Implémentation de la source de données locale pour les conversions
///
/// Effectue les calculs de conversion avec les formules standard
class ConverterLocalDataSourceImpl implements ConverterLocalDataSource {
  @override
  List<ConversionModel> convertPressure({
    required double value,
    required String fromUnit,
  }) {
    switch (fromUnit) {
      case 'bar':
        return [
          ConversionModel(value: value, unit: 'bar'),
          ConversionModel(value: value / 10, unit: 'MPa'),
          ConversionModel(value: value * 14.5038, unit: 'PSI'),
          ConversionModel(value: value * 10.1972, unit: 'mce'),
        ];
      case 'MPa':
        return [
          ConversionModel(value: value * 10, unit: 'bar'),
          ConversionModel(value: value, unit: 'MPa'),
          ConversionModel(value: value * 145.038, unit: 'PSI'),
          ConversionModel(value: value * 101.972, unit: 'mce'),
        ];
      case 'PSI':
        return [
          ConversionModel(value: value / 14.5038, unit: 'bar'),
          ConversionModel(value: value / 145.038, unit: 'MPa'),
          ConversionModel(value: value, unit: 'PSI'),
          ConversionModel(value: value * 0.703069, unit: 'mce'),
        ];
      case 'mce':
        return [
          ConversionModel(value: value / 10.1972, unit: 'bar'),
          ConversionModel(value: value / 101.972, unit: 'MPa'),
          ConversionModel(value: value * 1.42233, unit: 'PSI'),
          ConversionModel(value: value, unit: 'mce'),
        ];
      default:
        throw ArgumentError('Unité de pression non supportée: $fromUnit');
    }
  }

  @override
  List<ConversionModel> convertTemperature({
    required double value,
    required String fromUnit,
  }) {
    switch (fromUnit) {
      case '°C':
        return [
          ConversionModel(value: value + 273.15, unit: 'K'),
          ConversionModel(value: value, unit: '°C'),
          ConversionModel(value: (value * 9 / 5) + 32, unit: '°F'),
        ];
      case 'K':
        return [
          ConversionModel(value: value, unit: 'K'),
          ConversionModel(value: value - 273.15, unit: '°C'),
          ConversionModel(value: (value - 273.15) * 9 / 5 + 32, unit: '°F'),
        ];
      case '°F':
        final celsius = (value - 32) * 5 / 9;
        return [
          ConversionModel(value: celsius + 273.15, unit: 'K'),
          ConversionModel(value: celsius, unit: '°C'),
          ConversionModel(value: value, unit: '°F'),
        ];
      default:
        throw ArgumentError('Unité de température non supportée: $fromUnit');
    }
  }
}
