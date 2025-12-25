import 'package:equatable/equatable.dart';

/// Entité représentant un résultat de conversion
///
/// Contient une valeur numérique et son unité
class Conversion extends Equatable {
  final double value;
  final String unit;

  const Conversion({
    required this.value,
    required this.unit,
  });

  @override
  List<Object> get props => [value, unit];

  @override
  String toString() => '$value $unit';
}
