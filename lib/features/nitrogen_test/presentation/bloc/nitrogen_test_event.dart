import 'package:equatable/equatable.dart';

abstract class NitrogenTestEvent extends Equatable {
  const NitrogenTestEvent();
  @override
  List<Object> get props => [];
}

class CalculateTestEvent extends NitrogenTestEvent {
  final double initialPressure;
  final double initialTemperature;
  final double finalTemperature;

  const CalculateTestEvent({
    required this.initialPressure,
    required this.initialTemperature,
    required this.finalTemperature,
  });

  @override
  List<Object> get props => [initialPressure, initialTemperature, finalTemperature];
}
