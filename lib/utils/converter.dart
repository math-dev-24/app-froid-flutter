import 'package:app_froid/data/models/conversion_result.dart';

/// Conversions de pression

/// Convertit depuis bar vers toutes les unités
List<ConversionResult> barConvert(double value) {
  return [
    ConversionResult(value: value, unit: 'bar'),
    ConversionResult(value: value / 10, unit: 'MPa'),
    ConversionResult(value: value * 14.5038, unit: 'PSI'),
    ConversionResult(value: value * 10.1972, unit: 'mce'),
  ];
}

/// Convertit depuis MPa vers toutes les unités
List<ConversionResult> paConvert(double value) {
  return [
    ConversionResult(value: value * 10, unit: 'bar'),
    ConversionResult(value: value, unit: 'MPa'),
    ConversionResult(value: value * 145.038, unit: 'PSI'),
    ConversionResult(value: value * 101.972, unit: 'mce'),
  ];
}

/// Convertit depuis PSI vers toutes les unités
List<ConversionResult> psiConvert(double value) {
  return [
    ConversionResult(value: value / 14.5038, unit: 'bar'),
    ConversionResult(value: value / 145.038, unit: 'MPa'),
    ConversionResult(value: value, unit: 'PSI'),
    ConversionResult(value: value * 0.703069, unit: 'mce'),
  ];
}

/// Convertit depuis mce (mètres de colonne d'eau) vers toutes les unités
List<ConversionResult> mceConvert(double value) {
  return [
    ConversionResult(value: value / 10.1972, unit: 'bar'),
    ConversionResult(value: value / 101.972, unit: 'MPa'),
    ConversionResult(value: value * 1.42233, unit: 'PSI'),
    ConversionResult(value: value, unit: 'mce'),
  ];
}

/// Conversions de température

/// Convertit depuis Celsius vers toutes les unités
List<ConversionResult> cConvert(double value) {
  return [
    ConversionResult(value: value + 273.15, unit: 'K'),
    ConversionResult(value: value, unit: '°C'),
    ConversionResult(value: (value * 9 / 5) + 32, unit: '°F'),
  ];
}

/// Convertit depuis Kelvin vers toutes les unités
List<ConversionResult> kConvert(double value) {
  return [
    ConversionResult(value: value, unit: 'K'),
    ConversionResult(value: value - 273.15, unit: '°C'),
    ConversionResult(value: (value - 273.15) * 9 / 5 + 32, unit: '°F'),
  ];
}

/// Convertit depuis Fahrenheit vers toutes les unités
List<ConversionResult> fConvert(double value) {
  final celsius = (value - 32) * 5 / 9;
  return [
    ConversionResult(value: celsius + 273.15, unit: 'K'),
    ConversionResult(value: celsius, unit: '°C'),
    ConversionResult(value: value, unit: '°F'),
  ];
}
