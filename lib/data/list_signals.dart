import 'models/signal.dart';

/// Liste statique des types de signaux disponibles
class ListSignals {
  static const List<Signal> signals = [
    Signal(min: 4, max: 20, delta: 16, unit: 'mA'),
    Signal(min: 0, max: 20, delta: 20, unit: 'mA'),
    Signal(min: 0, max: 10, delta: 10, unit: 'V'),
    Signal(min: 1, max: 5, delta: 4, unit: 'V'),
  ];

  static const List<String> signalLabels = [
    '4 - 20 mA',
    '0 - 20 mA',
    '0 - 10 V',
    '1 - 5 V',
  ];

  static const List<String> units = [
    '°C', 'K', 'Pa', 'bar', 'F', 'A', 'W', 'kW',
    'V', 'mV', 'Hz', 'kHz', 's', 'ms', 'min', 'h',
    'd', 'mo', 'a', '%', 'm', 'mm', 'cm', 'km',
    'l/min', 'm³/h',
  ];
}
