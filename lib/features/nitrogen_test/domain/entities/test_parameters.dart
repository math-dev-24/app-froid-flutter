import 'package:equatable/equatable.dart';

/// Entité représentant les paramètres d'un test d'azote
class TestParameters extends Equatable {
  final double initialPressure;
  final double initialTemperature;
  final double finalTemperature;

  const TestParameters({
    required this.initialPressure,
    required this.initialTemperature,
    required this.finalTemperature,
  });

  @override
  List<Object> get props => [initialPressure, initialTemperature, finalTemperature];
}
