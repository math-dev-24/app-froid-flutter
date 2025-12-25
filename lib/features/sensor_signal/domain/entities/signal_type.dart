import 'package:equatable/equatable.dart';

/// Entité représentant un type de signal électrique
class SignalType extends Equatable {
  final double min;
  final double max;
  final double delta;
  final String unit;
  final String label;

  const SignalType({
    required this.min,
    required this.max,
    required this.delta,
    required this.unit,
    required this.label,
  });

  @override
  List<Object> get props => [min, max, delta, unit, label];

  @override
  String toString() => label;
}
