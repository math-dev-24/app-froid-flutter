import 'package:equatable/equatable.dart';

abstract class IntermediatePressureEvent extends Equatable {
  const IntermediatePressureEvent();

  @override
  List<Object> get props => [];
}

class CalculateIntermediatePressureEvent extends IntermediatePressureEvent {
  final double highPressure;
  final double lowPressure;

  const CalculateIntermediatePressureEvent({
    required this.highPressure,
    required this.lowPressure,
  });

  @override
  List<Object> get props => [highPressure, lowPressure];
}
