import 'package:equatable/equatable.dart';

/// Résultat d'une conversion de signal
class SensorConversionResult extends Equatable {
  final double value;
  final String unit;
  final String description;

  const SensorConversionResult({
    required this.value,
    required this.unit,
    required this.description,
  });

  @override
  List<Object> get props => [value, unit, description];

  @override
  String toString() => '${value.toStringAsFixed(2)} $unit';
}
